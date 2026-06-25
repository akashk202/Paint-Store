class NotificationEntity {
  final String key;
  final Map<String, dynamic> data;
  final String src; // 'p' for personal, 'g' for global

  const NotificationEntity({
    required this.key,
    required this.data,
    required this.src,
  });

  bool get isRead => data['isRead'] == true;
  int get timestamp => data['timestamp'] ?? 0;
  String get message => data['message'] ?? '';
  String get type => data['type'] ?? '';
}
