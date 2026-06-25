import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/services/visualizer_service.dart';
import 'visualizer_event.dart';
import 'visualizer_state.dart';

export 'visualizer_event.dart';
export 'visualizer_state.dart';

/// VisualizerBloc: manages color visualizer state.
/// Calls [VisualizerService] to process images via the backend API.
class VisualizerBloc extends Bloc<VisualizerEvent, VisualizerState> {
  VisualizerBloc() : super(const VisualizerState()) {
    on<VisualizerRequested>(_onRequested);
    on<VisualizerColorChanged>(_onColorChanged);
    on<VisualizerResultCleared>(_onResultCleared);
  }

  Future<void> _onRequested(
    VisualizerRequested event,
    Emitter<VisualizerState> emit,
  ) async {
    emit(state.copyWith(processing: true, clearError: true));
    try {
      // Convert color to hex string
      final color = state.color;
      final hex =
          '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';

      final resultUrl = await VisualizerService.instance.visualize(
        event.imageFile,
        hex,
        scene: event.scene,
      );
      emit(state.copyWith(resultUrl: resultUrl, processing: false));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
        processing: false,
      ));
    }
  }

  void _onColorChanged(
    VisualizerColorChanged event,
    Emitter<VisualizerState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _onResultCleared(
    VisualizerResultCleared event,
    Emitter<VisualizerState> emit,
  ) {
    emit(state.copyWith(clearResult: true, clearError: true));
  }
}
