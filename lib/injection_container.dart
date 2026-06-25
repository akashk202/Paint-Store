import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Core
import 'package:c_h_p/core/network/dio_client.dart';

// ── Auth Feature ────────────────────────────────────────────────────────────
import 'package:c_h_p/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:c_h_p/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:c_h_p/features/auth/domain/repositories/auth_repository.dart';
import 'package:c_h_p/features/auth/domain/usecases/login_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/register_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/logout_usecase.dart';
import 'package:c_h_p/features/auth/presentation/bloc/auth_bloc.dart';

// ── Products Feature ────────────────────────────────────────────────────────
import 'package:c_h_p/features/products/data/datasources/product_remote_data_source.dart';
import 'package:c_h_p/features/products/data/repositories/product_repository_impl.dart';
import 'package:c_h_p/features/products/domain/repositories/product_repository.dart'
    as products_domain;
import 'package:c_h_p/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:c_h_p/features/products/domain/usecases/search_products_usecase.dart';
import 'package:c_h_p/features/products/presentation/bloc/product_bloc.dart';

// ── Existing Repositories (reused as data sources for Phase 2 BLoCs) ───────
import 'package:c_h_p/data/repositories/cart_repository.dart';
import 'package:c_h_p/data/repositories/home_repository.dart';
import 'package:c_h_p/data/repositories/product_repository.dart';
import 'package:c_h_p/data/repositories/notifications_repository.dart';
import 'package:c_h_p/data/repositories/orders_repository.dart';
import 'package:c_h_p/data/repositories/stock_repository.dart';
import 'package:c_h_p/data/repositories/user_repository.dart';
import 'package:c_h_p/data/repositories/report_repository.dart';
import 'package:c_h_p/data/repositories/painters_repository.dart';
import 'package:c_h_p/data/repositories/recommendation_repository.dart';

// ── Phase 2 BLoCs ───────────────────────────────────────────────────────────
import 'package:c_h_p/features/cart/bloc/cart_bloc.dart';
import 'package:c_h_p/features/home/bloc/home_bloc.dart';
import 'package:c_h_p/features/notifications/bloc/notifications_bloc.dart';
import 'package:c_h_p/features/stock/bloc/stock_bloc.dart';
import 'package:c_h_p/features/checkout/bloc/checkout_bloc.dart';
import 'package:c_h_p/features/payment/bloc/payment_bloc.dart';
import 'package:c_h_p/features/user/bloc/user_bloc.dart';
import 'package:c_h_p/features/report/bloc/report_bloc.dart';
import 'package:c_h_p/features/painters/bloc/painters_bloc.dart';
import 'package:c_h_p/features/explore/bloc/explore_bloc.dart';
import 'package:c_h_p/features/visualizer/bloc/visualizer_bloc.dart';

/// Builds the [MultiProvider] widget that provides all dependencies.
///
/// **Provider is used ONLY for dependency injection — NOT state management.**
/// BLoCs are provided here for the entire app widget tree.
Widget buildInjectionContainer({required Widget child}) {
  return MultiProvider(
    providers: [
      // ════════════════════════════════════════════════════════════════════
      // CORE
      // ════════════════════════════════════════════════════════════════════
      Provider<DioClient>(create: (_) => DioClient()),

      // ════════════════════════════════════════════════════════════════════
      // AUTH FEATURE (Clean Architecture — full layers)
      // ════════════════════════════════════════════════════════════════════
      Provider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSourceImpl()),
      Provider<AuthRepository>(
        create: (ctx) => AuthRepositoryImpl(
          remoteDataSource: ctx.read<AuthRemoteDataSource>(),
        ),
      ),
      Provider<LoginUseCase>(
          create: (ctx) => LoginUseCase(ctx.read<AuthRepository>())),
      Provider<RegisterUseCase>(
          create: (ctx) => RegisterUseCase(ctx.read<AuthRepository>())),
      Provider<GoogleSignInUseCase>(
          create: (ctx) => GoogleSignInUseCase(ctx.read<AuthRepository>())),
      Provider<ResetPasswordUseCase>(
          create: (ctx) => ResetPasswordUseCase(ctx.read<AuthRepository>())),
      Provider<LogoutUseCase>(
          create: (ctx) => LogoutUseCase(ctx.read<AuthRepository>())),
      BlocProvider<AuthBloc>(
        create: (ctx) => AuthBloc(
          loginUseCase: ctx.read<LoginUseCase>(),
          registerUseCase: ctx.read<RegisterUseCase>(),
          googleSignInUseCase: ctx.read<GoogleSignInUseCase>(),
          resetPasswordUseCase: ctx.read<ResetPasswordUseCase>(),
          logoutUseCase: ctx.read<LogoutUseCase>(),
        ),
      ),

      // ════════════════════════════════════════════════════════════════════
      // PRODUCTS FEATURE (Clean Architecture — full layers)
      // ════════════════════════════════════════════════════════════════════
      Provider<ProductRemoteDataSource>(
          create: (_) => ProductRemoteDataSourceImpl()),
      Provider<products_domain.ProductRepository>(
        create: (ctx) => ProductRepositoryImpl(
          remoteDataSource: ctx.read<ProductRemoteDataSource>(),
        ),
      ),
      Provider<GetAllProductsUseCase>(
        create: (ctx) =>
            GetAllProductsUseCase(ctx.read<products_domain.ProductRepository>()),
      ),
      Provider<SearchProductsUseCase>(
        create: (ctx) =>
            SearchProductsUseCase(ctx.read<products_domain.ProductRepository>()),
      ),
      BlocProvider<ProductBloc>(
        create: (ctx) => ProductBloc(
          getAllProductsUseCase: ctx.read<GetAllProductsUseCase>(),
          searchProductsUseCase: ctx.read<SearchProductsUseCase>(),
        ),
      ),

      // ════════════════════════════════════════════════════════════════════
      // EXISTING REPOSITORIES (reused by Phase 2 BLoCs)
      // ════════════════════════════════════════════════════════════════════
      Provider<CartRepository>(create: (_) => CartRepository()),
      Provider<ProductRepository>(create: (_) => ProductRepository()),
      Provider<HomeRepository>(create: (_) => HomeRepository()),
      Provider<NotificationsRepository>(
          create: (_) => NotificationsRepository()),
      Provider<OrdersRepository>(create: (_) => OrdersRepository()),
      Provider<StockRepository>(create: (_) => StockRepository()),
      Provider<UserRepository>(create: (_) => UserRepository()),
      Provider<ReportRepository>(create: (_) => ReportRepository()),
      Provider<PaintersRepository>(create: (_) => PaintersRepository()),
      Provider<RecommendationRepository>(
          create: (_) => RecommendationRepository()),

      // ════════════════════════════════════════════════════════════════════
      // PHASE 2 BLoCs
      // ════════════════════════════════════════════════════════════════════
      BlocProvider<CartBloc>(
        create: (ctx) =>
            CartBloc(repository: ctx.read<CartRepository>())
              ..add(const SubscribeToCart()),
      ),
      BlocProvider<HomeBloc>(
        create: (ctx) => HomeBloc(
          productRepository: ctx.read<ProductRepository>(),
          homeRepository: ctx.read<HomeRepository>(),
        ),
      ),
      BlocProvider<NotificationsBloc>(
        create: (ctx) => NotificationsBloc(
          repository: ctx.read<NotificationsRepository>(),
          userRepository: ctx.read<UserRepository>(),
        ),
      ),
      BlocProvider<StockBloc>(
        create: (ctx) =>
            StockBloc(repository: ctx.read<StockRepository>())
              ..add(const SubscribeToStock()),
      ),
      BlocProvider<CheckoutBloc>(
        create: (ctx) =>
            CheckoutBloc(ordersRepository: ctx.read<OrdersRepository>()),
      ),
      BlocProvider<PaymentBloc>(
        create: (ctx) =>
            PaymentBloc(ordersRepository: ctx.read<OrdersRepository>()),
      ),
      BlocProvider<UserBloc>(
        create: (ctx) =>
            UserBloc(repository: ctx.read<UserRepository>()),
      ),
      BlocProvider<ReportBloc>(
        create: (ctx) =>
            ReportBloc(repository: ctx.read<ReportRepository>()),
      ),
      BlocProvider<PaintersBloc>(
        create: (ctx) =>
            PaintersBloc(repository: ctx.read<PaintersRepository>())
              ..add(const SubscribeToPainters()),
      ),
      BlocProvider<ExploreBloc>(
        create: (ctx) =>
            ExploreBloc(repository: ctx.read<RecommendationRepository>()),
      ),
      BlocProvider<VisualizerBloc>(create: (_) => VisualizerBloc()),
    ],
    child: child,
  );
}
