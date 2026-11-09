part of 'location_picker_cubit.dart';

sealed class LocationPickerState extends Equatable {
  const LocationPickerState();

  @override
  List<Object?> get props => [];
}

final class LocationPickerInitial extends LocationPickerState {
  const LocationPickerInitial();
}

final class LocationPickerLoading extends LocationPickerState {
  final LatLng point;
  const LocationPickerLoading(this.point);

  @override
  List<Object?> get props => [point];
}

final class LocationPickerSuccess extends LocationPickerState {
  final PickedLocation location;
  const LocationPickerSuccess(this.location);

  @override
  List<Object?> get props => [location];
}

final class LocationPickerError extends LocationPickerState {
  final PickedLocation location;
  final String message;
  const LocationPickerError(this.location, this.message);

  @override
  List<Object?> get props => [location, message];
}
