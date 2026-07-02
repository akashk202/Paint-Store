import '../entities/painter_entity.dart';

abstract class PaintersRepository {
  Stream<List<Painter>> watchPainters();
}


// Either<Failure, T>
