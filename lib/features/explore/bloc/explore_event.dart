import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/product_model.dart';

/// Events dispatched by the Explore UI to the ExploreBloc.
abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

/// Load recommended/popular products.
class LoadRecommendedProducts extends ExploreEvent {
  final int limit;

  const LoadRecommendedProducts({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Load similar products based on an anchor product.
class LoadSimilarProducts extends ExploreEvent {
  final Product anchor;
  final int limit;

  const LoadSimilarProducts({required this.anchor, this.limit = 10});

  @override
  List<Object?> get props => [anchor.key, limit];
}
