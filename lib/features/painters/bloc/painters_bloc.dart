import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/painters_repository.dart';
import 'painters_event.dart';
import 'painters_state.dart';

export 'painters_event.dart';
export 'painters_state.dart';

/// PaintersBloc: manages painters list via real-time Firebase stream.
class PaintersBloc extends Bloc<PaintersEvent, PaintersState> {
  final PaintersRepository repository;
  StreamSubscription? _paintersSub;

  PaintersBloc({required this.repository}) : super(const PaintersInitial()) {
    on<SubscribeToPainters>(_onSubscribe);
    on<PaintersDataUpdated>(_onDataUpdated);
  }

  Future<void> _onSubscribe(
    SubscribeToPainters event,
    Emitter<PaintersState> emit,
  ) async {
    emit(const PaintersLoading());
    await _paintersSub?.cancel();
    _paintersSub = repository.paintersStream().listen(
      (painters) => add(PaintersDataUpdated(painters)),
      onError: (error) =>
          emit(PaintersError('Failed to load painters: ${error.toString()}')),
    );
  }

  void _onDataUpdated(
    PaintersDataUpdated event,
    Emitter<PaintersState> emit,
  ) {
    emit(PaintersLoaded(event.painters));
  }

  @override
  Future<void> close() {
    _paintersSub?.cancel();
    return super.close();
  }
}
