import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/home/domain/entities/home_product_entity.dart';
import 'package:c_h_p/features/home/domain/repositories/home_repository.dart';
import 'package:c_h_p/features/home/domain/usecases/get_all_home_products.dart';
import 'package:c_h_p/features/home/domain/usecases/observe_unread_notifications.dart';
import 'package:c_h_p/features/home/presentation/viewmodel/home_view_model.dart';

class _FakeHomeRepository implements HomeRepository {
  final List<HomeProductEntity> _items;
  final _controller = StreamController<int>.broadcast();

  _FakeHomeRepository(this._items);

  @override
  Future<List<HomeProductEntity>> fetchAllProducts() async => _items;

  @override
  Stream<int> unreadCountStream(String uid) => _controller.stream;

  void emit(int v) => _controller.add(v);

  Future<void> close() async => _controller.close();
}

HomeProductEntity _makeProduct(String key) => HomeProductEntity(
      key: key,
      name: 'P$key',
      description: 'desc',
      stock: 1,
      mainImageUrl: 'https://example.com/img.png',
      backgroundImageUrl: '',
      benefits: const [],
      packSizes: const [],
      brochureUrl: '',
    );

void main() {
  test('HomeViewModel loadAllProducts() populates products and clears loading',
      () async {
    final products = [_makeProduct('1'), _makeProduct('2')];
    final homeRepo = _FakeHomeRepository(products);
    final vm = HomeViewModel(
      getAllHomeProducts: GetAllHomeProducts(homeRepo),
      observeUnreadNotifications: ObserveUnreadNotifications(homeRepo),
    );

    expect(vm.state.loading, false);
    expect(vm.state.products, isEmpty);

    await vm.loadAllProducts();

    expect(vm.state.loading, false);
    expect(vm.state.products.length, 2);
    expect(vm.state.error, isNull);

    await homeRepo.close();
  });

  test('HomeViewModel observeUnread() updates unreadCount from stream',
      () async {
    final homeRepo = _FakeHomeRepository([]);
    final vm = HomeViewModel(
      getAllHomeProducts: GetAllHomeProducts(homeRepo),
      observeUnreadNotifications: ObserveUnreadNotifications(homeRepo),
    );

    vm.observeUnread('uid-1');

    homeRepo.emit(3);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.unreadCount, 3);

    homeRepo.emit(0);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(vm.state.unreadCount, 0);

    await homeRepo.close();
  });
}
