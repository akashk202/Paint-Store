import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/product_repository.dart';
import 'package:c_h_p/data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

/// HomeBloc: manages home page state.
/// Loads featured products and tracks unread notification count.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;
  final HomeRepository homeRepository;
  StreamSubscription<int>? _unreadSub;

  HomeBloc({
    required this.productRepository,
    required this.homeRepository,
  }) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SubscribeToUnreadCount>(_onSubscribeUnread);
    on<UnreadCountUpdated>(_onUnreadUpdated);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final products = await productRepository.fetchAll();
      emit(HomeLoaded(featuredProducts: products));
    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> _onSubscribeUnread(
    SubscribeToUnreadCount event,
    Emitter<HomeState> emit,
  ) async {
    await _unreadSub?.cancel();
    _unreadSub = homeRepository.unreadCountStream(event.uid).listen(
      (count) => add(UnreadCountUpdated(count)),
      onError: (_) => add(const UnreadCountUpdated(0)),
    );
  }

  void _onUnreadUpdated(
    UnreadCountUpdated event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(unreadNotificationCount: event.count));
    }
  }

  @override
  Future<void> close() {
    _unreadSub?.cancel();
    return super.close();
  }
}
