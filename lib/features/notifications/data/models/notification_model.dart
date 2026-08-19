import 'package:equatable/equatable.dart';

/// One entry from `GET /notifications`. [title]/[body] come back as
/// `easy_localization` dot-path keys (e.g.
/// `"notifications.booking.completed.manager.title"`) rather than literal
/// text — call `.tr()` on them directly; a key missing from our translation
/// files just falls back to showing the raw string, so this is always safe.
class NotificationModel extends Equatable {
  final String id;
  final String type; // "booked" | "accepted" | "started" | "completed" | ...
  final String title;
  final String body;
  final int? appointmentId;
  final DateTime? date;
  final DateTime? readAt;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.appointmentId,
    this.date,
    this.readAt,
    this.createdAt,
  });

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        appointmentId: json['appointment_id'] as int?,
        date: DateTime.tryParse(json['date'] as String? ?? ''),
        readAt: json['read_at'] == null ? null : DateTime.tryParse(json['read_at'] as String),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );

  @override
  List<Object?> get props => [id, type, title, body, appointmentId, date, readAt, createdAt];
}
