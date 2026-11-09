import 'package:equatable/equatable.dart';

class AppointmentCallModel extends Equatable {
  const AppointmentCallModel({
    this.id,
    required this.callId,
    required this.status,
    this.startedAt,
    this.joinedAt,
    this.endedAt,
    this.cancelledAt,
  });

  final int? id;
  final String callId;
  final String status;
  final String? startedAt;
  final String? joinedAt;
  final String? endedAt;
  final String? cancelledAt;

  bool get isFinished =>
      status == 'ended' ||
      status == 'cancelled' ||
      endedAt != null ||
      cancelledAt != null;

  bool get isOngoing => !isFinished && callId.isNotEmpty;

  bool get isWaitingForJoin => isOngoing && status == 'started';

  factory AppointmentCallModel.fromJson(Map<String, dynamic> json) =>
      AppointmentCallModel(
        id: json['id'] as int?,
        callId: json['call_id']?.toString() ?? '',
        status: json['status'] as String? ?? '',
        startedAt: json['started_at'] as String?,
        joinedAt: json['joined_at'] as String?,
        endedAt: json['ended_at'] as String?,
        cancelledAt: json['cancelled_at'] as String?,
      );

  static AppointmentCallModel? maybeFromJson(dynamic json) =>
      json is Map<String, dynamic> ? AppointmentCallModel.fromJson(json) : null;

  @override
  List<Object?> get props =>
      [id, callId, status, startedAt, joinedAt, endedAt, cancelledAt];
}
