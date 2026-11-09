import 'package:equatable/equatable.dart';

class HomeVisitAddress extends Equatable {
  final String address;
  final String notes;
  final double? lat;
  final double? lng;

  const HomeVisitAddress({
    required this.address,
    this.notes = '',
    this.lat,
    this.lng,
  });

  bool get hasLocation => lat != null && lng != null;

  Map<String, dynamic> toJson() => {
        'address': address,
        if (notes.isNotEmpty) 'address_notes': notes,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };

  @override
  List<Object?> get props => [address, notes, lat, lng];
}
