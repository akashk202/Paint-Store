import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_recommended_products.dart';
import 'explore_state.dart';

class ExploreNotifier extends StateNotifier<ExploreState> {
  final GetRecommendedProducts getRecommendedProducts;
  bool _loaded = false;

  ExploreNotifier({
    required this.getRecommendedProducts,
  }) : super(const ExploreState(loading: true));

  Future<void> loadRecommended({int limit = 10}) async {
    if (_loaded) return;

    state = state.copyWith(loading: true, error: null);
    try {
      final items = await getRecommendedProducts(limit: limit);
      state = state.copyWith(loading: false, items: items, error: null);
      _loaded = true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> refresh({int limit = 10}) async {
    _loaded = false;
    return loadRecommended(limit: limit);
  }

  Future<void> precacheHeroImages(BuildContext context) async {
    try {
      await Future.wait([
        precacheImage(const AssetImage('assets/image_b8a96a.jpg'), context),
        precacheImage(const AssetImage('assets/image_b8aca7.jpg'), context),
        precacheImage(const AssetImage('assets/image_b8b0ca.jpg'), context),
      ]);
    } catch (_) {
      // Ignore precache failures; explore screen should still render.
    }
  }
}
