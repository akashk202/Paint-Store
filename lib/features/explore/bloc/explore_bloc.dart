import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/recommendation_repository.dart';
import 'package:c_h_p/services/recommendation_service.dart';
import 'explore_event.dart';
import 'explore_state.dart';

export 'explore_event.dart';
export 'explore_state.dart';

/// ExploreBloc: handles recommended and similar product loading.
/// Wraps [RecommendationRepository] and [RecommendationService].
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final RecommendationRepository repository;

  ExploreBloc({required this.repository}) : super(const ExploreInitial()) {
    on<LoadRecommendedProducts>(_onLoadRecommended);
    on<LoadSimilarProducts>(_onLoadSimilar);
  }

  Future<void> _onLoadRecommended(
    LoadRecommendedProducts event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());
    try {
      final products = await repository.fetchRecommended(limit: event.limit);
      emit(ExploreRecommendedLoaded(products));
    } catch (e) {
      emit(ExploreError('Failed to load recommendations: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSimilar(
    LoadSimilarProducts event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());
    try {
      final products = await RecommendationService.fetchSimilarProducts(
        event.anchor,
        limit: event.limit,
      );
      emit(ExploreSimilarLoaded(
        products: products,
        anchorKey: event.anchor.key,
      ));
    } catch (e) {
      emit(ExploreError('Failed to load similar products: ${e.toString()}'));
    }
  }
}
