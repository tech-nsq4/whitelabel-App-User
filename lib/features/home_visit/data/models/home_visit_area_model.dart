import 'package:equatable/equatable.dart';

class HomeVisitAreaModel extends Equatable {
  final int id;
  final int? cityId;
  final String name;
  final String cost;

  const HomeVisitAreaModel({
    required this.id,
    this.cityId,
    required this.name,
    this.cost = '',
  });

  double get costValue => double.tryParse(cost) ?? 0;

  bool get hasCost => cost.isNotEmpty;

  factory HomeVisitAreaModel.fromJson(Map<String, dynamic> json) => HomeVisitAreaModel(
        id: int.tryParse('${json['id']}') ?? 0,
        cityId: int.tryParse('${json['city_id']}'),
        name: json['name']?.toString() ?? '',
        cost: json['cost'] == null ? '' : '${json['cost']}',
      );

  static HomeVisitAreaModel? maybeFromJson(dynamic json) =>
      json is Map<String, dynamic> ? HomeVisitAreaModel.fromJson(json) : null;

  static List<HomeVisitAreaModel> listFromJson(dynamic json) => json is List
      ? json.whereType<Map<String, dynamic>>().map(HomeVisitAreaModel.fromJson).toList()
      : const [];

  Map<String, dynamic> toJson() => {'id': id, 'city_id': cityId, 'name': name, 'cost': cost};

  @override
  List<Object?> get props => [id, cityId, name, cost];
}
