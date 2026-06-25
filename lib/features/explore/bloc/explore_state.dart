import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/product_model.dart';

/// States emitted by the ExploreBloc.
abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

/// Explore data is being loaded.
class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

/// Recommended products loaded.
class ExploreRecommendedLoaded extends ExploreState {
  final List<Product> products;

  const ExploreRecommendedLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

/// Similar products loaded.
class ExploreSimilarLoaded extends ExploreState {
  final List<Product> products;
  final String anchorKey;

  const ExploreSimilarLoaded({required this.products, required this.anchorKey});

  @override
  List<Object?> get props => [products, anchorKey];
}

/// An error occurred while loading explore data.
class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}
