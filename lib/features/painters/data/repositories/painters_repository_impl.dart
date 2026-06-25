import 'package:c_h_p/features/painters/data/models/painter_model.dart';
import '../../domain/repositories/painters_repository.dart';
import '../datasources/painters_remote_datasource.dart';

class PaintersRepositoryImpl implements PaintersRepository {
  final PaintersRemoteDataSource remoteDataSource;

  PaintersRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Painter>> watchPainters() {
    return remoteDataSource.watchPainters();
  }
}
