import 'package:geolocator/geolocator.dart';

/// Thin wrapper around `geolocator` — walks the permission dance and hands
/// back `null` instead of throwing whenever location isn't available
/// (service off, permission denied/denied-forever, or any read failure), so
/// callers can fall back gracefully (e.g. skip the "nearest doctor" filter).
class LocationHelper {
  LocationHelper._();

  static Future<Position?> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
    } catch (_) {
      return null;
    }
  }
}
