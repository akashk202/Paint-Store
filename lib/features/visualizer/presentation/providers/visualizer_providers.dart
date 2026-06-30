import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/visualizer_remote_datasource.dart';
import '../../data/repositories/visualizer_repository_impl.dart';
import '../../domain/repositories/visualizer_repository.dart';
import '../../domain/usecases/visualizer_usecases.dart';
import 'visualizer_notifier.dart';

final _visualizerRemoteDataSourceProvider = Provider<VisualizerRemoteDataSource>((ref) {
  return VisualizerRemoteDataSourceImpl();
});

final visualizerRepositoryProvider = Provider<VisualizerRepository>((ref) {
  return VisualizerRepositoryImpl(ref.read(_visualizerRemoteDataSourceProvider));
});

final visualizeImageUseCaseProvider = Provider<VisualizeImage>((ref) {
  return VisualizeImage(ref.read(visualizerRepositoryProvider));
});

final visualizerNotifierProvider =
    StateNotifierProvider<VisualizerNotifier, VisualizerState>((ref) {
  return VisualizerNotifier(
    visualizeImage: ref.read(visualizeImageUseCaseProvider),
  );
});
