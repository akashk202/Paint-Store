import 'package:c_h_p/features/painters/data/models/painter_model.dart';

abstract class PaintersRepository {
  Stream<List<Painter>> watchPainters();
}
