import 'package:flutter_riverpod/flutter_riverpod.dart';



// Clean Architecture Cart imports
import 'package:c_h_p/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:c_h_p/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:c_h_p/features/cart/domain/repositories/cart_repository.dart';
import 'package:c_h_p/features/cart/domain/usecases/get_cart_stream.dart';
import 'package:c_h_p/features/cart/domain/usecases/update_quantity.dart';
import 'package:c_h_p/features/cart/domain/usecases/change_size.dart';
import 'package:c_h_p/features/cart/domain/usecases/remove_item.dart';
import 'package:c_h_p/features/cart/domain/usecases/clear_cart.dart';
import 'package:c_h_p/features/cart/domain/usecases/add_or_update_item.dart';
import 'package:c_h_p/features/cart/domain/usecases/fetch_product_details.dart';
import 'package:c_h_p/features/cart/presentation/providers/cart_notifier.dart';
import 'package:c_h_p/features/cart/presentation/providers/cart_state.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ============================================
// Clean Architecture Cart (Riverpod)
// ============================================

// Data Source Provider (Private to avoid presentation layer bypassing repository)
final _cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl(
    db: FirebaseDatabase.instance,
    auth: FirebaseAuth.instance,
  );
});

// Repository Provider
final cartCleanRepositoryProvider = Provider<CartRepository>((ref) {
  final dataSource = ref.read(_cartRemoteDataSourceProvider);
  return CartRepositoryImpl(dataSource);
});

// Use Case Providers
final cartGetStreamUseCaseProvider = Provider<GetCartStream>((ref) {
  return GetCartStream(ref.read(cartCleanRepositoryProvider));
});

final cartUpdateQuantityUseCaseProvider = Provider<UpdateQuantity>((ref) {
  return UpdateQuantity(ref.read(cartCleanRepositoryProvider));
});

final cartChangeSizeUseCaseProvider = Provider<ChangeSize>((ref) {
  return ChangeSize(ref.read(cartCleanRepositoryProvider));
});

final cartRemoveItemUseCaseProvider = Provider<RemoveItem>((ref) {
  return RemoveItem(ref.read(cartCleanRepositoryProvider));
});

final cartClearCartUseCaseProvider = Provider<ClearCart>((ref) {
  return ClearCart(ref.read(cartCleanRepositoryProvider));
});

final cartAddOrUpdateItemUseCaseProvider = Provider<AddOrUpdateItem>((ref) {
  return AddOrUpdateItem(ref.read(cartCleanRepositoryProvider));
});

final cartFetchProductDetailsUseCaseProvider = Provider<FetchProductDetails>((ref) {
  return FetchProductDetails(ref.read(cartCleanRepositoryProvider));
});

// Notifier Provider (Clean Architecture + Riverpod)
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    getCartStream: ref.read(cartGetStreamUseCaseProvider),
    updateQuantity: ref.read(cartUpdateQuantityUseCaseProvider),
    changeSize: ref.read(cartChangeSizeUseCaseProvider),
    removeItem: ref.read(cartRemoveItemUseCaseProvider),
    clearCart: ref.read(cartClearCartUseCaseProvider),
    addOrUpdateItem: ref.read(cartAddOrUpdateItemUseCaseProvider),
  );
});

final cartCleanNotifierProvider = cartNotifierProvider;
