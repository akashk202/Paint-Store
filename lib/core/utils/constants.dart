/// Application-wide constants.

class AppConstants {
  AppConstants._();

  /// Firebase Realtime Database URL
  static const String firebaseDatabaseUrl =
      'https://smart-paint-shop-default-rtdb.firebaseio.com';

  /// App display name
  static const String appName = 'Smart Paint Shop';

  /// Admin email (hardcoded for role override)
  static const String adminEmail = 'akashkrishna389@gmail.com';

  /// Default user role
  static const String defaultUserRole = 'Customer';

  /// Recommendation service base URL (set via --dart-define=RECO_API=...)
  static String recoApiBaseUrl =
      const String.fromEnvironment('RECO_API', defaultValue: '');

  /// Visualizer service base URL (set via --dart-define=VIZ_BASE_URL=...)
  static const String vizBaseUrl = String.fromEnvironment(
    'VIZ_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
