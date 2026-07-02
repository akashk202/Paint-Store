/// Pure domain entity for a Painter.
class Painter {
  final String key;
  final String name;
  final String location;
  final String? phone;
  final int dailyFare;
  final String? imageUrl;

  const Painter({
    required this.key,
    required this.name,
    required this.location,
    this.phone,
    required this.dailyFare,
    this.imageUrl,
  });
}
