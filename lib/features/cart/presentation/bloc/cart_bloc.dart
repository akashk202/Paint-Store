import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/features/cart/domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

export 'cart_event.dart';
export 'cart_state.dart';

/// CartBloc: manages cart state via real-time Firebase stream.
/// Delegates all data operations to [CartRepository] (domain contract).
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  StreamSubscription<Map<String, Map<String, dynamic>>>? _cartSub;

  CartBloc({required this.repository}) : super(const CartInitial()) {
    on<SubscribeToCart>(_onSubscribe);
    on<CartUpdated>(_onCartUpdated);
    on<UpdateCartQuantity>(_onUpdateQuantity);
    on<ChangeCartSize>(_onChangeSize);
    on<RemoveCartItem>(_onRemoveItem);
    on<ClearCart>(_onClearCart);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onSubscribe(
    SubscribeToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    await _cartSub?.cancel();
    _cartSub = repository.cartStream().listen(
      (items) => add(CartUpdated(items)),
      onError: (error) => add(const CartUpdated({})),
    );
  }

  void _onCartUpdated(
    CartUpdated event,
    Emitter<CartState> emit,
  ) {
    emit(CartLoaded(event.items));
  }

  Future<void> _onUpdateQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.updateQuantity(
        productKey: event.productKey,
        quantity: event.quantity,
      );
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onChangeSize(
    ChangeCartSize event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.changeSize(
        productKey: event.productKey,
        size: event.size,
        price: event.price,
      );
    } catch (e) {
      emit(CartError('Failed to change size: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.removeItem(event.productKey);
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.clearCart();
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.addOrUpdateItem(
        productKey: event.productKey,
        name: event.name,
        mainImageUrl: event.mainImageUrl,
        size: event.size,
        price: event.price,
      );
    } catch (e) {
      emit(CartError('Failed to add to cart: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _cartSub?.cancel();
    return super.close();
  }
}
