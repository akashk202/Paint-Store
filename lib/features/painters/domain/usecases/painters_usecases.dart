import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/painter_entity.dart';
import '../repositories/painters_repository.dart';

class WatchPainters implements StreamUseCase<List<Painter>, NoParams> {
  final PaintersRepository repository;

  WatchPainters(this.repository);

  @override
  Stream<List<Painter>> call(NoParams params) {
    return repository.watchPainters();
  }
}
