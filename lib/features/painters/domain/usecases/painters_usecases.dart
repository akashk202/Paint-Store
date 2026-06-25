import 'package:c_h_p/features/painters/data/models/painter_model.dart';
import '../repositories/painters_repository.dart';

class WatchPainters {
  final PaintersRepository repository;

  WatchPainters(this.repository);

  Stream<List<Painter>> call() {
    return repository.watchPainters();
  }
}
