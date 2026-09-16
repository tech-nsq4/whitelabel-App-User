import 'package:equatable/equatable.dart';

class SplashItemModel extends Equatable {
  const SplashItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  final int id;
  final String title;
  final String description;
  final String image;

  factory SplashItemModel.fromJson(Map<String, dynamic> json) => SplashItemModel(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, title, description, image];
}
