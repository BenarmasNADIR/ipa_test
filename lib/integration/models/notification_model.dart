// notification_model.dart
// Contains Notification model

class Notification {
  final int id;
  final int userId;
  final String message;
  final String createdAt;
  final bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user'],
      message: json['message'],
      createdAt: json['created_at'],
      isRead: json['is_read'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': userId,
        'message': message,
        'is_read': isRead,
      };
}
