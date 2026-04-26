import 'package:firebase_database/firebase_database.dart';
import 'package:c_h_p/features/painters/data/models/painter_model.dart';

abstract class PaintersRemoteDataSource {
  Stream<List<Painter>> watchPainters();
}

class PaintersRemoteDataSourceImpl implements PaintersRemoteDataSource {
  final DatabaseReference dbRef;

  PaintersRemoteDataSourceImpl(this.dbRef);

  @override
  Stream<List<Painter>> watchPainters() {
    return dbRef.child('painters').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Painter>[];
      }
      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);
      final list = <Painter>[];
      raw.forEach((key, value) {
        try {
          list.add(Painter.fromMap(key, value));
        } catch (_) {}
      });
      return list;
    });
  }
}
