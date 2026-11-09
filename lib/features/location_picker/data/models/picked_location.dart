import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class PickedLocation extends Equatable {
  final double lat;
  final double lng;
  final String address;

  const PickedLocation({
    required this.lat,
    required this.lng,
    this.address = '',
  });

  factory PickedLocation.fromPoint(LatLng point, {String address = ''}) =>
      PickedLocation(lat: point.latitude, lng: point.longitude, address: address);

  LatLng get point => LatLng(lat, lng);

  String get coordinatesLabel => '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';

  String get displayAddress => address.isNotEmpty ? address : coordinatesLabel;

  @override
  List<Object?> get props => [lat, lng, address];
}
