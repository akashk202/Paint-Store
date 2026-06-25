import '../../domain/entities/cart_item.dart';

class CartState {
  final bool loading;
  final List<CartItem> items;
  final Object? error;

  CartState({
    this.loading = false,
    this.items = const [],
    this.error,
  });

  double get totalPrice {
    return items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    bool? loading,
    List<CartItem>? items,
    Object? error,
  }) {
    return CartState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
    );
  }
}