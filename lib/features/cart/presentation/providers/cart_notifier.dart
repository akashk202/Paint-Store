import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_cart_stream.dart';
import '../../domain/usecases/update_quantity.dart';
import '../../domain/usecases/change_size.dart';
import '../../domain/usecases/remove_item.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/add_or_update_item.dart';
import 'cart_state.dart';

class CartNotifier extends StateNotifier<CartState> {
  final GetCartStream _getCartStream;
  final UpdateQuantity _updateQuantityUseCase;
  final ChangeSize _changeSizeUseCase;
  final RemoveItem _removeItemUseCase;
  final ClearCart _clearCartUseCase;
  final AddOrUpdateItem _addOrUpdateItemUseCase;

  StreamSubscription? _subscription;

  CartNotifier({
    required GetCartStream getCartStream,
    required UpdateQuantity updateQuantity,
    required ChangeSize changeSize,
    required RemoveItem removeItem,
    required ClearCart clearCart,
    required AddOrUpdateItem addOrUpdateItem,
  })  : _getCartStream = getCartStream,
        _updateQuantityUseCase = updateQuantity,
        _changeSizeUseCase = changeSize,
        _removeItemUseCase = removeItem,
        _clearCartUseCase = clearCart,
        _addOrUpdateItemUseCase = addOrUpdateItem,
        super(CartState()) {
    subscribeToCart();
  }

  // Subscribe to cart stream
  void subscribeToCart() {
    state = state.copyWith(loading: true, error: null);

    _subscription?.cancel();
    _subscription = _getCartStream().listen(
      (items) {
        state = state.copyWith(loading: false, items: items);
      },
      onError: (error) {
        state = state.copyWith(loading: false, error: error);
      },
    );
  }

  // Update item quantity
  Future<void> updateItemQuantity(String productKey, int quantity) async {
    try {
      await _updateQuantityUseCase(productKey, quantity);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // Change item size
  Future<void> changeItemSize(String productKey, String size, String price) async {
    try {
      await _changeSizeUseCase(
        productKey: productKey,
        size: size,
        price: price,
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // Remove item from cart
  Future<void> removeCartItem(String productKey) async {
    try {
      await _removeItemUseCase(productKey);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // Clear entire cart
  Future<void> clearAllItems() async {
    try {
      await _clearCartUseCase();
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // Add or update item
  Future<void> addOrUpdateCartItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  }) async {
    try {
      await _addOrUpdateItemUseCase(
        productKey: productKey,
        name: name,
        imageUrl: imageUrl,
        size: size,
        price: price,
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  // Compatibility wrappers while the rest of the UI is being migrated.
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  }) {
    return updateItemQuantity(productKey, quantity);
  }

  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  }) {
    return changeItemSize(productKey, size, price);
  }

  Future<void> removeItem(String productKey) {
    return removeCartItem(productKey);
  }

  Future<void> clearCart() {
    return clearAllItems();
  }

  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    String? imageUrl,
    String? mainImageUrl,
    required String size,
    required String price,
  }) {
    return addOrUpdateCartItem(
      productKey: productKey,
      name: name,
      imageUrl: imageUrl ?? mainImageUrl ?? '',
      size: size,
      price: price,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
