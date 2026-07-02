import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';

import '../../domain/usecases/get_all_home_products.dart';
import '../../domain/usecases/observe_unread_notifications.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final GetAllHomeProducts getAllHomeProducts;
  final ObserveUnreadNotifications observeUnreadNotifications;
  bool _loaded = false;
  StreamSubscription<int>? _unreadSubscription;
  String? _observedUid;

  HomeNotifier({
    required this.getAllHomeProducts,
    required this.observeUnreadNotifications,
  }) : super(const HomeState());

  Future<void> loadAllProducts() async {
    if (_loaded) return;

    state = state.copyWith(loading: true, error: null);
    final result = await getAllHomeProducts(const NoParams());
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (products) {
        state = state.copyWith(loading: false, products: products, error: null);
        _loaded = true;
      },
    );
  }

  Future<void> refreshProducts() async {
    _loaded = false;
    return loadAllProducts();
  }

  void observeUnread(String uid) {
    if (_observedUid == uid && _unreadSubscription != null) return;

    _unreadSubscription?.cancel();
    _observedUid = uid;
    _unreadSubscription = observeUnreadNotifications(uid).listen((count) {
      state = state.copyWith(unreadCount: count);
    });
  }

  @override
  void dispose() {
    _unreadSubscription?.cancel();
    super.dispose();
  }
}
