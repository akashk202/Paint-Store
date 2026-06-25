import 'package:equatable/equatable.dart';

/// Events dispatched by the Cart UI to the CartBloc.
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribe to the real-time cart stream from Firebase.
class SubscribeToCart extends CartEvent {
  const SubscribeToCart();
}

/// Cart data updated from the Firebase stream.
class CartUpdated extends CartEvent {
  final Map<String, Map<String, dynamic>> items;

  const CartUpdated(this.items);

  @override
  List<Object?> get props => [items];
}

/// Update the quantity of a specific cart item.
class UpdateCartQuantity extends CartEvent {
  final String productKey;
  final int quantity;

  const UpdateCartQuantity({required this.productKey, required this.quantity});

  @override
  List<Object?> get props => [productKey, quantity];
}

/// Change the selected pack size of a cart item.
class ChangeCartSize extends CartEvent {
  final String productKey;
  final String size;
  final String price;

  const ChangeCartSize({
    required this.productKey,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, size, price];
}

/// Remove a single item from the cart.
class RemoveCartItem extends CartEvent {
  final String productKey;

  const RemoveCartItem(this.productKey);

  @override
  List<Object?> get props => [productKey];
}

/// Clear the entire cart.
class ClearCart extends CartEvent {
  const ClearCart();
}

/// Add or update an item in the cart.
class AddToCart extends CartEvent {
  final String productKey;
  final String name;
  final String mainImageUrl;
  final String size;
  final String price;

  const AddToCart({
    required this.productKey,
    required this.name,
    required this.mainImageUrl,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, name, mainImageUrl, size, price];
}
