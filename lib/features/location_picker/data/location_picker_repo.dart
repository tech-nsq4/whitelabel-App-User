import 'dart:ui';

import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/location_helper.dart';

class LocationPickerRepo {
  LocationPickerRepo({Geocoding? geocoding}) : _geocoding = geocoding ?? Geocoding();

  static const _geocodingTimeout = Duration(seconds: 8);
  static const _locationTimeout = Duration(seconds: 12);

  final Geocoding _geocoding;

  Future<LatLng?> lastKnownLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<LatLng?> currentLocation() async {
    final position = await LocationHelper.getCurrentPosition()
        .timeout(_locationTimeout, onTimeout: () => null);
    if (position == null) return null;
    return LatLng(position.latitude, position.longitude);
  }

  Future<String> addressFor(LatLng point, {Locale? locale}) async {
    final placemarks = await _geocoding
        .placemarkFromCoordinates(point.latitude, point.longitude, locale: locale)
        .timeout(_geocodingTimeout);
    if (placemarks.isEmpty) return '';
    final placemark = placemarks.first;
    final parts = <String>[];
    for (final part in [
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.administrativeArea,
    ]) {
      final value = part?.trim() ?? '';
      if (value.isNotEmpty && !parts.contains(value)) parts.add(value);
    }
    return parts.join('، ');
  }

  Future<LatLng?> search(String query, {Locale? locale}) async {
    final results = await _geocoding.locationFromAddress(query, locale: locale).timeout(_geocodingTimeout);
    if (results.isEmpty) return null;
    return LatLng(results.first.latitude, results.first.longitude);
  }
}
