import 'package:c_h_p/features/explore/domain/entities/explore_product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/explore/domain/repositories/explore_repository.dart';
import 'package:c_h_p/features/explore/domain/usecases/get_recommended_products.dart';
import 'package:c_h_p/features/explore/presentation/viewmodel/explore_view_model.dart';

class _FakeExploreRepository implements ExploreRepository {
  @override
  Future<List<ExploreProductEntity>> fetchRecommended({int limit = 10}) async {
    return const [
      ExploreProductEntity(
        key: 'p1',
        name: 'Sample Paint',
        brand: 'BrandX',
        category: 'interior',
        description: 'desc',
        stock: 10,
        subCategory: 'wall',
        mainImageUrl: 'https://example.com/img.png',
        backgroundImageUrl: 'https://example.com/bg.png',
        benefits: [],
        packSizes: [],
        brochureUrl: 'https://example.com/brochure.pdf',
      ),
    ];
  }
}

void main() {
  test('ExploreViewModel loads recommended products successfully', () async {
    final repo = _FakeExploreRepository();
    final vm = ExploreViewModel(
      getRecommendedProducts: GetRecommendedProducts(repo),
    );

    expect(vm.state.loading, true);
    await vm.loadRecommended(limit: 1);
    expect(vm.state.loading, false);
    expect(vm.state.items.length, 1);
    expect(vm.state.error, isNull);
  });

  test('ExploreViewModel handles error', () async {
    final repo = _ErrorExploreRepository();
    final vm = ExploreViewModel(
      getRecommendedProducts: GetRecommendedProducts(repo),
    );

    await vm.loadRecommended(limit: 1);
    expect(vm.state.loading, false);
    expect(vm.state.items, isEmpty);
    expect(vm.state.error, isNotNull);
  });
}

class _ErrorExploreRepository implements ExploreRepository {
  @override
  Future<List<ExploreProductEntity>> fetchRecommended({int limit = 10}) async {
    throw Exception('boom');
  }
}
