import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/features/painters/data/models/painter_model.dart';
import '../../domain/usecases/painters_usecases.dart';

class PaintersState {
  final bool loading;
  final List<Painter> painters;
  final Object? error;
  
  const PaintersState({
    this.loading = false,
    this.painters = const [],
    this.error,
  });

  PaintersState copyWith({
    bool? loading,
    List<Painter>? painters,
    Object? error,
  }) {
    return PaintersState(
      loading: loading ?? this.loading,
      painters: painters ?? this.painters,
      error: error,
    );
  }
}

class PaintersNotifier extends StateNotifier<PaintersState> {
  final WatchPainters _watchPainters;
  StreamSubscription<List<Painter>>? _sub;

  PaintersNotifier({required WatchPainters watchPainters})
      : _watchPainters = watchPainters,
        super(const PaintersState()) {
    _subscribe();
  }

  void _subscribe() {
    state = state.copyWith(loading: true, error: null);
    _sub?.cancel();
    _sub = _watchPainters().listen(
      (list) {
        state = state.copyWith(loading: false, painters: list, error: null);
      },
      onError: (e) {
        state = state.copyWith(loading: false, error: e);
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
