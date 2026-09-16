import 'package:equatable/equatable.dart';

enum BannerTargetType { offer, doctor, clinic, none }

BannerTargetType bannerTargetTypeFromJson(String? raw) {
  switch (raw) {
    case 'offer':
      return BannerTargetType.offer;
    case 'doctor':
      return BannerTargetType.doctor;
    case 'clinic':
      return BannerTargetType.clinic;
    default:
      return BannerTargetType.none;
  }
}

class BannerModel extends Equatable {
  final int id;
  final String title;
  final String image;
  final BannerTargetType type;
  final int? targetId;

  const BannerModel({
    required this.id,
    required this.title,
    required this.image,
    this.type = BannerTargetType.none,
    this.targetId,
  });

  bool get hasTarget => type != BannerTargetType.none && targetId != null;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        image: json['image'] as String? ?? '',
        type: bannerTargetTypeFromJson(json['type'] as String?),
        targetId: json['offer_id'] as int?,
      );

  @override
  List<Object?> get props => [id, title, image, type, targetId];
}
