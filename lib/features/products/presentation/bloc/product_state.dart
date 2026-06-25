import 'package:equatable/equatable.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';

/// States emitted by the ProductBloc.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state before products are loaded.
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Products are being fetched.
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Products loaded successfully.
class ProductLoaded extends ProductState {
  final List<ProductEntity> products;

  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

/// Search results returned.
class ProductSearchResults extends ProductState {
  final List<ProductEntity> products;
  final String query;

  const ProductSearchResults({required this.products, required this.query});

  @override
  List<Object?> get props => [products, query];
}

/// An error occurred while fetching products.
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
