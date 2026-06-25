import 'package:equatable/equatable.dart';

/// Events dispatched by Product UI to the ProductBloc.
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load all products from the data source.
class LoadProducts extends ProductEvent {
  const LoadProducts();
}

/// Search products by query string.
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear the current search and show all products.
class ClearSearch extends ProductEvent {
  const ClearSearch();
}
