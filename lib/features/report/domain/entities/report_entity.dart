class ReportEntity {
  final String key;
  final String userId;
  final String name;
  final String email;
  final String issue;
  final int timestamp;
  final String status;

  ReportEntity({
    required this.key,
    required this.userId,
    required this.name,
    required this.email,
    required this.issue,
    required this.timestamp,
    required this.status,
  });

  factory ReportEntity.fromMap(String key, Map<String, dynamic> map) {
    return ReportEntity(
      key: key,
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'Anonymous',
      email: map['email'] ?? 'No Email',
      issue: map['issue'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      status: map['status'] ?? 'Pending',
    );
  }
}
