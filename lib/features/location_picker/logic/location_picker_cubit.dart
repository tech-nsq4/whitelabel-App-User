import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/location_picker_repo.dart';
import '../data/models/picked_location.dart';

part 'location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit(this._repo) : super(const LocationPickerInitial());

  static const _retryDelay = Duration(milliseconds: 700);

  final LocationPickerRepo _repo;
  LatLng? _pendingPoint;
  Locale? _pendingLocale;
  bool _resolving = false;

  PickedLocation? get selectedLocation => switch (state) {
        LocationPickerSuccess(:final location) => location,
        LocationPickerError(:final location) => location,
        _ => null,
      };

  Future<void> resolve(LatLng point, {Locale? locale}) async {
    _pendingPoint = point;
    _pendingLocale = locale;
    if (isClosed) return;
    emit(LocationPickerLoading(point));
    if (_resolving) return;
    _resolving = true;
    try {
      while (_pendingPoint != null && !isClosed) {
        final target = _pendingPoint!;
        final targetLocale = _pendingLocale;
        _pendingPoint = null;
        final address = await _addressWithRetry(target, targetLocale);
        if (isClosed || _pendingPoint != null) continue;
        if (address != null) {
          emit(LocationPickerSuccess(PickedLocation.fromPoint(target, address: address)));
        } else {
          emit(LocationPickerError(
            PickedLocation.fromPoint(target),
            LocaleKeys.locationPicker_addressUnavailable.tr(),
          ));
        }
      }
    } finally {
      _resolving = false;
    }
  }

  Future<String?> _addressWithRetry(LatLng point, Locale? locale) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        return await _repo.addressFor(point, locale: locale);
      } catch (_) {
        if (attempt == 0) await Future<void>.delayed(_retryDelay);
        if (isClosed || _pendingPoint != null) return null;
      }
    }
    return null;
  }

  Future<LatLng?> lastKnownLocation() => _repo.lastKnownLocation();

  Future<LatLng?> currentLocation({bool silent = false}) async {
    final point = await _repo.currentLocation();
    if (point == null && !silent) AppOverlay.showError(LocaleKeys.homeVisit_locationUnavailable.tr());
    return point;
  }

  Future<LatLng?> search(String query, {Locale? locale}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    try {
      final point = await _repo.search(trimmed, locale: locale);
      if (point == null) AppOverlay.showError(LocaleKeys.locationPicker_noResults.tr());
      return point;
    } catch (_) {
      AppOverlay.showError(LocaleKeys.locationPicker_noResults.tr());
      return null;
    }
  }
}
