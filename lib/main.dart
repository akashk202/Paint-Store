import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:c_h_p/features/notifications/data/datasources/fcm_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/features/notifications/data/datasources/fcm_background.dart';
import 'package:c_h_p/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:c_h_p/features/notifications/presentation/pages/notifications_page.dart';
import 'package:c_h_p/features/explore/data/datasources/recommendation_remote_datasource.dart';

import 'firebase_options.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'package:c_h_p/core/presentation/pages/loading_screen.dart';
import 'package:c_h_p/core/presentation/pages/onboarding_screen.dart';
import 'package:c_h_p/features/home/presentation/pages/home_page.dart';
import 'test_helpers.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("DEBUG: Before Firebase.initializeApp");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("DEBUG: After Firebase.initializeApp");

  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://smart-paint-shop-default-rtdb.firebaseio.com',
  );
  debugPrint("DEBUG: After FirebaseDatabase.instanceFor");

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  debugPrint("DEBUG: After FirebaseMessaging.onBackgroundMessage");

  final api = const String.fromEnvironment('RECO_API');
  if (api.isNotEmpty) {
    RecommendationRemoteDataSource.apiBaseUrl = api;
  }
  debugPrint("DEBUG: After RECO_API check");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class _MyAppState extends State<MyApp> {
  bool? _isFirstTime;
  bool _assetsPrecached = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initServices();
      _precacheAppImages();
    });
    if (!kIsWeb) {
      // Keep FCM registration updated with auth state
      FirebaseAuth.instance.authStateChanges().listen((user) {
        FCMRemoteDataSource.updateForUser(user);
      });
      // Foreground: show a local notification
      FCMRemoteDataSource.listenForegroundMessages(onMessage: (m) {
        final title = m.notification?.title ?? 'Notification';
        final body = m.notification?.body ?? '';
        final payload = m.data.isNotEmpty ? m.data.toString() : null;
        NotificationRemoteDataSource.instance.showForegroundNotification(
            title: title, body: body, payload: payload);
      });

      // Deep-link when user taps an FCM notification from background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        NotificationRemoteDataSource.instance.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
      });
    }
  }

  Future<void> _initServices() async {
    if (kIsWeb) return;
    try {
      await NotificationRemoteDataSource.instance.init();
      await FCMRemoteDataSource.requestPermission();
      await FCMRemoteDataSource.updateForUser(FirebaseAuth.instance.currentUser);
    } catch (e) {
      debugPrint('Startup service init error: $e');
    }
  }

  // Precache frequently used asset images once app has a build context
  void _precacheAppImages() {
    if (_assetsPrecached) return;
    final ctx = NotificationRemoteDataSource.instance.navigatorKey.currentContext;
    if (ctx == null) {
      // Try again on next frame if the navigator context isn't ready yet
      WidgetsBinding.instance.addPostFrameCallback((_) => _precacheAppImages());
      return;
    }
    precacheImage(const AssetImage('assets/image_b8a96a.jpg'), ctx);
    precacheImage(const AssetImage('assets/image_b8aca7.jpg'), ctx);
    precacheImage(const AssetImage('assets/image_b8b0ca.jpg'), ctx);
    _assetsPrecached = true;
  }

  Future<void> _checkFirstTime() async {
    // Skip onboarding in test mode
    if (skipOnboardingScreen) {
      setState(() {
        _isFirstTime = false;
      });
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      setState(() {
        _isFirstTime = isFirstTime;
      });

      if (isFirstTime) {
        prefs.setBool('isFirstTime', false);
      }
    } catch (e) {
      debugPrint('SharedPreferences error: $e');
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstTime == null) {
      // While we check first time status, show loading
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoadingScreen(nextPage: SizedBox()),
      );
    }

    return MaterialApp(
      title: 'Smart Paint Shop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.iOS: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.linux: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.macOS: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.windows: _NoAnimationPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationRemoteDataSource.instance.navigatorKey,
      home: _isFirstTime! ? const OnboardingScreen() : _getNextPage(),
    );
  }

  Widget _getNextPage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomePage(); // Logged-in user
    } else {
      return const LoginPage(); // Not logged in
    }
  }
}
