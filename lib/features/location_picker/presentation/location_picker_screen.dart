import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/di/injection.dart';
import '../data/models/picked_location.dart';
import '../logic/location_picker_cubit.dart';
import 'widgets/location_picker_address_card.dart';
import 'widgets/location_picker_center_pin.dart';
import 'widgets/location_picker_my_location_button.dart';
import 'widgets/location_picker_search_bar.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initialLocation});

  final PickedLocation? initialLocation;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const _fallbackCenter = LatLng(30.0444, 31.2357);
  static const _focusedZoom = 16.5;
  static const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const _userAgentPackage = 'com.whiteLable.user';

  late final LocationPickerCubit _cubit = getIt<LocationPickerCubit>();
  final _mapController = MapController();
  final _searchController = TextEditingController();
  bool _locating = false;

  LatLng get _initialCenter => widget.initialLocation?.point ?? _fallbackCenter;

  @override
  void dispose() {
    _cubit.close();
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onMapReady() {
    final initial = widget.initialLocation;
    if (initial != null) {
      _cubit.resolve(initial.point, locale: context.locale);
      return;
    }
    _locateOnOpen();
  }

  Future<void> _locateOnOpen() async {
    setState(() => _locating = true);
    final lastKnown = await _cubit.lastKnownLocation();
    if (!mounted) return;
    if (lastKnown != null) _moveTo(lastKnown);

    final current = await _cubit.currentLocation(silent: lastKnown != null);
    if (!mounted) return;
    setState(() => _locating = false);
    if (current != null) {
      _moveTo(current);
    } else if (lastKnown == null) {
      _moveTo(_fallbackCenter);
    }
  }

  void _moveTo(LatLng point) {
    _mapController.move(point, _focusedZoom);
    _cubit.resolve(point, locale: context.locale);
  }

  Future<void> _goToMyLocation() async {
    setState(() => _locating = true);
    final point = await _cubit.currentLocation();
    if (!mounted) return;
    setState(() => _locating = false);
    if (point != null) _moveTo(point);
  }

  Future<void> _search(String query) async {
    FocusScope.of(context).unfocus();
    final point = await _cubit.search(query, locale: context.locale);
    if (point != null && mounted) _moveTo(point);
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
      _cubit.resolve(event.camera.center, locale: context.locale);
    }
  }

  void _confirm() {
    final location = _cubit.selectedLocation;
    if (location == null) return;
    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: _focusedZoom,
                      onMapReady: _onMapReady,
                      onMapEvent: _onMapEvent,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: _tileUrl,
                        userAgentPackageName: _userAgentPackage,
                      ),
                    ],
                  ),
                  const LocationPickerCenterPin(),
                  PositionedDirectional(
                    top: 0,
                    start: 16.w,
                    end: 16.w,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: LocationPickerSearchBar(
                          controller: _searchController,
                          onSearch: _search,
                          onBack: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: 16.w,
                    bottom: 16.h,
                    child: LocationPickerMyLocationButton(
                      onTap: _goToMyLocation,
                      loading: _locating,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<LocationPickerCubit, LocationPickerState>(
              builder: (context, state) => LocationPickerAddressCard(
                state: state,
                onConfirm: _confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
