import '../entities/painter_entity.dart';
import '../repositories/painters_repository.dart';

class WatchPainters {
  final PaintersRepository repository;

  WatchPainters(this.repository);

  Stream<List<Painter>> call() {
    return repository.watchPainters();
  }
}


// implements UseCase
