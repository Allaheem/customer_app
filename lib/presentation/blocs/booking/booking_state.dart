part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

// Initial state, map is shown, ready for search
class BookingInitial extends BookingState {}

// User is typing in the search bar
class BookingSearchingDestination extends BookingState {}

// Search results (predictions) are loaded
class BookingDestinationSearchResultsLoaded extends BookingState {
  final List<dynamic> predictions; // Placeholder for PlacePrediction model

  const BookingDestinationSearchResultsLoaded(this.predictions);

  @override
  List<Object?> get props => [predictions];
}

// Destination selected, calculating route and fare estimate
class BookingCalculatingRoute extends BookingState {
  final String pickupAddress;
  final String destinationAddress;
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;

  const BookingCalculatingRoute({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.pickupLatLng,
    required this.destinationLatLng,
  });

   @override
  List<Object?> get props => [pickupAddress, destinationAddress, pickupLatLng, destinationLatLng];
}

// Route and initial fare estimate calculated, ready for confirmation
class BookingRideDetailsReady extends BookingState {
  final String pickupAddress;
  final String destinationAddress;
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;
  final String selectedVehicleType;
  final dynamic routeDetails; // Placeholder for route (polyline, duration, distance)
  final dynamic fareEstimate; // Placeholder for fare estimate

  const BookingRideDetailsReady({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.pickupLatLng,
    required this.destinationLatLng,
    required this.selectedVehicleType,
    this.routeDetails,
    this.fareEstimate,
  });

  @override
  List<Object?> get props => [
        pickupAddress,
        destinationAddress,
        pickupLatLng,
        destinationLatLng,
        selectedVehicleType,
        routeDetails,
        fareEstimate,
      ];

  // Helper to copy state with updated vehicle type or fare
  BookingRideDetailsReady copyWith({
    String? selectedVehicleType,
    dynamic fareEstimate,
  }) {
    return BookingRideDetailsReady(
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      pickupLatLng: pickupLatLng,
      destinationLatLng: destinationLatLng,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      routeDetails: routeDetails,
      fareEstimate: fareEstimate ?? this.fareEstimate,
    );
  }
}

// User confirmed, sending ride request to backend
class BookingRequestingRide extends BookingState {
   final BookingRideDetailsReady rideDetails; // Carry over details
   const BookingRequestingRide(this.rideDetails);

   @override
   List<Object?> get props => [rideDetails];
}

// Ride request sent, waiting for driver assignment
class BookingFindingDriver extends BookingState {
  final String rideId; // ID of the created ride request
  final LatLng pickupLatLng;

  const BookingFindingDriver({required this.rideId, required this.pickupLatLng});

  @override
  List<Object?> get props => [rideId, pickupLatLng];
}

// Driver assigned, en route to pickup
class BookingDriverAssigned extends BookingState {
  final String rideId;
  final dynamic driverDetails; // Placeholder for Driver model
  final LatLng pickupLatLng;
  final LatLng driverLatLng;
  final String etaToPickup;

  const BookingDriverAssigned({
    required this.rideId,
    required this.driverDetails,
    required this.pickupLatLng,
    required this.driverLatLng,
    required this.etaToPickup,
  });

  @override
  List<Object?> get props => [rideId, driverDetails, pickupLatLng, driverLatLng, etaToPickup];
}

// Driver arrived at pickup location
class BookingDriverArrived extends BookingState {
  final String rideId;
  final dynamic driverDetails;
  final LatLng pickupLatLng;

  const BookingDriverArrived({
    required this.rideId,
    required this.driverDetails,
    required this.pickupLatLng,
  });

   @override
  List<Object?> get props => [rideId, driverDetails, pickupLatLng];
}

// Ride is in progress
class BookingRideActive extends BookingState {
  final String rideId;
  final dynamic driverDetails;
  final LatLng driverLatLng;
  final LatLng destinationLatLng;
  final String etaToDestination;

  const BookingRideActive({
    required this.rideId,
    required this.driverDetails,
    required this.driverLatLng,
    required this.destinationLatLng,
    required this.etaToDestination,
  });

  @override
  List<Object?> get props => [rideId, driverDetails, driverLatLng, destinationLatLng, etaToDestination];
}

// Ride completed, waiting for rating/payment
class BookingRideCompleted extends BookingState {
  final String rideId;
  final dynamic finalFare; // Placeholder for final fare details

  const BookingRideCompleted({required this.rideId, this.finalFare});

  @override
  List<Object?> get props => [rideId, finalFare];
}

// Ride was cancelled (by user or driver)
class BookingRideCancelled extends BookingState {
  final String rideId;
  final String reason;

  const BookingRideCancelled({required this.rideId, required this.reason});

   @override
  List<Object?> get props => [rideId, reason];
}

// Error state
class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

