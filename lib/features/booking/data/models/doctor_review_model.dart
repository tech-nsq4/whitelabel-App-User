import 'package:equatable/equatable.dart';

import '../../../../core/utils/convert_helper.dart';

class DoctorReviewModel extends Equatable {
  final int id;
  final int rate;
  final String? comment;
  final DateTime? ratedAt;
  final String userName;

  const DoctorReviewModel({
    required this.id,
    required this.rate,
    this.comment,
    this.ratedAt,
    this.userName = '',
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) => DoctorReviewModel(
        id: json['id'] as int,
        rate: (json['rate'] as num?)?.toInt() ?? 0,
        comment: (json['comment'] as String?)?.trim(),
        ratedAt: DateTime.tryParse(json['rated_at'] as String? ?? ''),
        userName: (json['user'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      );

  String get displayDate =>
      ratedAt == null ? '' : ConvertHelper.formatDateTime(ratedAt!.toIso8601String());

  @override
  List<Object?> get props => [id, rate, comment, ratedAt, userName];
}
