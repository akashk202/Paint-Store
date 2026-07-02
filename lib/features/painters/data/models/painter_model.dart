import '../../../painters/domain/entities/painter_entity.dart';
export '../../../painters/domain/entities/painter_entity.dart' show Painter;

/// Data-layer model that adds Firebase/JSON serialisation on top of the
/// domain [Painter] entity.
class PainterModel extends Painter {
  const PainterModel({
    required super.key,
    required super.name,
    required super.location,
    super.phone,
    required super.dailyFare,
    super.imageUrl,
  });

  factory PainterModel.fromMap(String key, Map<dynamic, dynamic> map) {
    return PainterModel(
      key: key,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'],
      dailyFare: map['dailyFare'] ?? 0,
      imageUrl: map['imageUrl'],
    );
  }
}
