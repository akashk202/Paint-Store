class Painter {
  final String key;
  final String name;
  final String location;
  final String? phone;
  final int dailyFare;
  final String? imageUrl;

  Painter({
    required this.key,
    required this.name,
    required this.location,
    this.phone,
    required this.dailyFare,
    this.imageUrl,
  });

  factory Painter.fromMap(String key, Map<dynamic, dynamic> map) {
    return Painter(
      key: key,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'],
      dailyFare: map['dailyFare'] ?? 0,
      imageUrl: map['imageUrl'],
    );
  }
}
