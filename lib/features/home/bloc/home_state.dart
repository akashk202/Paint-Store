import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/product_model.dart';

/// States emitted by the HomeBloc.
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before home data is loaded.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Home data is being loaded.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Home data loaded successfully.
class HomeLoaded extends HomeState {
  final List<Product> featuredProducts;
  final int unreadNotificationCount;

  const HomeLoaded({
    required this.featuredProducts,
    this.unreadNotificationCount = 0,
  });

  HomeLoaded copyWith({
    List<Product>? featuredProducts,
    int? unreadNotificationCount,
  }) {
    return HomeLoaded(
      featuredProducts: featuredProducts ?? this.featuredProducts,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
    );
  }

  @override
  List<Object?> get props => [featuredProducts, unreadNotificationCount];
}

/// An error occurred while loading home data.
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
