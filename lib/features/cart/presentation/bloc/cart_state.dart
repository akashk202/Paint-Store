import 'package:equatable/equatable.dart';

/// States emitted by the CartBloc.
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state before cart is loaded.
class CartInitial extends CartState {
  const CartInitial();
}

/// Cart is being loaded.
class CartLoading extends CartState {
  const CartLoading();
}

/// Cart items loaded/updated from Firebase stream.
class CartLoaded extends CartState {
  final Map<String, Map<String, dynamic>> items;

  const CartLoaded(this.items);

  int get itemCount => items.length;

  double get totalAmount {
    double total = 0.0;
    for (final entry in items.values) {
      final price = _parsePrice(entry['selectedPrice']?.toString() ?? '0');
      final qty = (entry['quantity'] ?? 0) as int;
      total += price * qty;
    }
    return total;
  }

  static double _parsePrice(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9\.]'), '');
    return double.tryParse(sanitized) ?? 0.0;
  }

  @override
  List<Object?> get props => [items];
}

/// An error occurred while loading/updating the cart.
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
