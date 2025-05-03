part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

// Event when user starts typing a destination
class DestinationSearchQueryChanged extends BookingEvent {
  final String query;

  const DestinationSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Event when user selects a destination from search results
class DestinationSelected extends BookingEvent {
  final String placeId;
  final String description;
  // TODO: Add LatLng pickupLatLng if needed (or get from LocationBloc)

  const DestinationSelected({required this.placeId, required this.description});

  @override
  List<Object?> get props => [placeId, description];
}

// Event when user changes the selected vehicle type on confirmation screen
class VehicleTypeSelected extends BookingEvent {
  final String vehicleType;

  const VehicleTypeSelected(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

// Event when user confirms the ride request
class ConfirmRideRequested extends BookingEvent {
   // Assumes pickup/destination details are already in the state
   const ConfirmRideRequested();
}

// Event when user cancels the ride (either during request or active ride)
class CancelRideRequested extends BookingEvent {
  final String rideId; // ID of the ride to cancel

  const CancelRideRequested(this.rideId);

   @override
  List<Object?> get props => [rideId];
}

// Internal event triggered by backend/repository updates (e.g., driver assigned, location update)
class RideStatusUpdated extends BookingEvent {
  final dynamic rideUpdateData; // Placeholder for actual ride update model

  const RideStatusUpdated(this.rideUpdateData);

  @override
  List<Object?> get props => [rideUpdateData];
}

// Event to clear search results or reset state
class ClearBookingSearch extends BookingEvent {}

// Event when user wants to go back from confirmation screen to search again
class EditRideDetails extends BookingEvent {}

