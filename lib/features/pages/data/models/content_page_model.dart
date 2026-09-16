import 'package:equatable/equatable.dart';

class ContentPageModel extends Equatable {
  final int id;
  final String slug;
  final String title;
  final String description;
  final Map<String, String> titleTranslations;
  final Map<String, String> descriptionTranslations;

  const ContentPageModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    this.titleTranslations = const {},
    this.descriptionTranslations = const {},
  });

  factory ContentPageModel.fromJson(Map<String, dynamic> json) {
    final translations = json['translations'] as Map<String, dynamic>? ?? const {};
    return ContentPageModel(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      titleTranslations: _stringMap(translations['title']),
      descriptionTranslations: _stringMap(translations['description']),
    );
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((key, v) => MapEntry(key.toString(), v?.toString() ?? ''))
      ..removeWhere((_, v) => v.isEmpty);
  }

  String localizedTitle(String languageCode) =>
      titleTranslations[languageCode] ?? title;

  String localizedDescription(String languageCode) =>
      descriptionTranslations[languageCode] ?? description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'description': description,
        'translations': {
          'title': titleTranslations,
          'description': descriptionTranslations,
        },
      };

  @override
  List<Object?> get props =>
      [id, slug, title, description, titleTranslations, descriptionTranslations];
}
