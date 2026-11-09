import 'package:equatable/equatable.dart';

class HomeVisitCityModel extends Equatable {
  final int id;
  final String name;

  const HomeVisitCityModel({required this.id, required this.name});

  factory HomeVisitCityModel.fromJson(Map<String, dynamic> json) => HomeVisitCityModel(
        id: int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
      );

  static HomeVisitCityModel? maybeFromJson(dynamic json) =>
      json is Map<String, dynamic> ? HomeVisitCityModel.fromJson(json) : null;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
