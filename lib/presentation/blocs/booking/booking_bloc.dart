import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Assuming LatLng is needed

// TODO: Import Repositories (Places, Directions, Booking)
// TODO: Import Models (PlacePrediction, RouteDetails, FareEstimate, Ride, Driver)

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  // TODO: Inject Repositories
  // final PlacesRepository _placesRepository;
  // final DirectionsRepository _directionsRepository;
  // final BookingRepository _bookingRepository;
  // final LocationBloc _locationBloc; // To get current location
  // StreamSubscription? _rideStatusSubscription;

  BookingBloc(/* required this._placesRepository, ... */) : super(BookingInitial()) {
    on<DestinationSearchQueryChanged>(_onDestinationSearchQueryChanged);
    on<DestinationSelected>(_onDestinationSelected);
    on<VehicleTypeSelected>(_onVehicleTypeSelected);
    on<ConfirmRideRequested>(_onConfirmRideRequested);
    on<CancelRideRequested>(_onCancelRideRequested);
    on<RideStatusUpdated>(_onRideStatusUpdated);
    on<ClearBookingSearch>(_onClearBookingSearch);
    on<EditRideDetails>(_onEditRideDetails);
  }

  Future<void> _onDestinationSearchQueryChanged(
    DestinationSearchQueryChanged event,
    Emitter<BookingState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(BookingInitial()); // Go back to initial state if query is cleared
      return;
    }
    emit(BookingSearchingDestination());
    try {
      // TODO: Call _placesRepository.searchPlaces(event.query)
      // print("Searching places for: ${event.query}");
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
      // Placeholder results
      final List<dynamic> predictions = [
        {'id': 'place_1', 'description': '${event.query} Result 1'},
        {'id': 'place_2', 'description': '${event.query} Result 2'},
      ];
      emit(BookingDestinationSearchResultsLoaded(predictions));
    } catch (e) {
      emit(BookingError("Failed to search destinations: ${e.toString()}"));
    }
  }

  Future<void> _onDestinationSelected(
    DestinationSelected event,
    Emitter<BookingState> emit,
  ) async {
    // TODO: Get current location from LocationBloc or state
    const LatLng currentLatLng = LatLng(24.7136, 46.6753); // Placeholder
    final String currentAddress = "Current Location Address"; // Placeholder

    emit(BookingCalculatingRoute(
      pickupAddress: currentAddress,
      destinationAddress: event.description,
      pickupLatLng: currentLatLng,
      destinationLatLng: const LatLng(24.7420, 46.6996), // TODO: Get LatLng from place details using event.placeId
    ));

    try {
      // TODO: Call _directionsRepository.getDirections(currentLatLng, destinationLatLng)
      // TODO: Call backend/repository to get fare estimate
      // print("Calculating route and fare for: ${event.description}");
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API calls

      // Placeholder data
      final routeDetails = {'polyline': 'dummy_polyline', 'duration': '15 mins', 'distance': '10 km'};
      final fareEstimate = {'amount': 25.0, 'currency': 'SAR'};
      const LatLng destinationLatLng = LatLng(24.7420, 46.6996); // Use actual fetched LatLng

      emit(BookingRideDetailsReady(
        pickupAddress: currentAddress,
        destinationAddress: event.description,
        pickupLatLng: currentLatLng,
        destinationLatLng: destinationLatLng,
        selectedVehicleType: 'standard', // Default type
        routeDetails: routeDetails,
        fareEstimate: fareEstimate,
      ));
    } catch (e) {
      emit(BookingError("Failed to calculate route/fare: ${e.toString()}"));
      // Optionally revert to a previous state or show error on the map
      emit(BookingInitial()); // Revert to initial for simplicity
    }
  }

  Future<void> _onVehicleTypeSelected(
    VehicleTypeSelected event,
    Emitter<BookingState> emit,
  ) async {
    if (state is BookingRideDetailsReady) {
      final currentState = state as BookingRideDetailsReady;
      // TODO: Recalculate fare estimate based on event.vehicleType
      // print("Recalculating fare for type: ${event.vehicleType}");
      await Future.delayed(const Duration(milliseconds: 200)); // Simulate API call
      final newFareEstimate = {'amount': event.vehicleType == 'accessible' ? 35.0 : 25.0, 'currency': 'SAR'}; // Placeholder

      emit(currentState.copyWith(
        selectedVehicleType: event.vehicleType,
        fareEstimate: newFareEstimate,
      ));
    }
  }

  Future<void> _onConfirmRideRequested(
    ConfirmRideRequested event,
    Emitter<BookingState> emit,
  ) async {
    if (state is BookingRideDetailsReady) {
      final currentState = state as BookingRideDetailsReady;
      emit(BookingRequestingRide(currentState));
      try {
        // TODO: Call _bookingRepository.createRideRequest(...)
        // print("Sending ride request to backend...");
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        final String newRideId = "ride_${DateTime.now().millisecondsSinceEpoch}"; // Placeholder ID

        // TODO: Start listening to ride status updates from repository/backend for this rideId
        // _rideStatusSubscription?.cancel();
        // _rideStatusSubscription = _bookingRepository.getRideStatusStream(newRideId).listen((update) {
        //   add(RideStatusUpdated(update));
        // });

        emit(BookingFindingDriver(rideId: newRideId, pickupLatLng: currentState.pickupLatLng));
      } catch (e) {
        emit(BookingError("Failed to request ride: ${e.toString()}"));
        // Revert to details screen to allow retry
        emit(currentState);
      }
    }
  }

  Future<void> _onCancelRideRequested(
    CancelRideRequested event,
    Emitter<BookingState> emit,
  ) async {
    // TODO: Call _bookingRepository.cancelRide(event.rideId)
    // print("Cancelling ride: ${event.rideId}");
    // Stop listening to updates for this ride
    // _rideStatusSubscription?.cancel();
    // _rideStatusSubscription = null;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    emit(BookingRideCancelled(rideId: event.rideId, reason: "Cancelled by user"));
    // After cancellation, usually go back to the initial map screen
    await Future.delayed(const Duration(seconds: 1));
    emit(BookingInitial());
  }

  void _onRideStatusUpdated(
    RideStatusUpdated event,
    Emitter<BookingState> emit,
  ) {
    // TODO: Process the rideUpdateData and emit the appropriate state
    // This logic depends heavily on the structure of rideUpdateData
    // print("Received ride status update: ${event.rideUpdateData}");

    // Example Logic (replace with actual data parsing):
    final update = event.rideUpdateData as Map; // Assuming it's a map
    final rideId = update['rideId'] as String? ?? 'unknown_ride';
    final status = update['status'] as String? ?? 'unknown';

    switch (status) {
      case 'driver_assigned':
        emit(BookingDriverAssigned(
          rideId: rideId,
          driverDetails: update['driver'], // Placeholder
          pickupLatLng: LatLng(update['pickupLat'], update['pickupLng']), // Placeholder
          driverLatLng: LatLng(update['driverLat'], update['driverLng']), // Placeholder
          etaToPickup: update['etaPickup'], // Placeholder
        ));
        break;
      case 'driver_arrived':
         emit(BookingDriverArrived(
           rideId: rideId,
           driverDetails: update['driver'], // Placeholder
           pickupLatLng: LatLng(update['pickupLat'], update['pickupLng']), // Placeholder
         ));
        break;
      case 'ride_started':
         emit(BookingRideActive(
           rideId: rideId,
           driverDetails: update['driver'], // Placeholder
           driverLatLng: LatLng(update['driverLat'], update['driverLng']), // Placeholder
           destinationLatLng: LatLng(update['destLat'], update['destLng']), // Placeholder
           etaToDestination: update['etaDest'], // Placeholder
         ));
        break;
      case 'ride_completed':
         // Stop listening to updates for this ride
         // _rideStatusSubscription?.cancel();
         // _rideStatusSubscription = null;
         emit(BookingRideCompleted(
           rideId: rideId,
           finalFare: update['finalFare'], // Placeholder
         ));
        break;
       case 'ride_cancelled':
         // Stop listening to updates for this ride
         // _rideStatusSubscription?.cancel();
         // _rideStatusSubscription = null;
         emit(BookingRideCancelled(
           rideId: rideId,
           reason: update['cancelReason'] ?? 'Cancelled by system/driver', // Placeholder
         ));
         // Optionally delay and go back to initial state
         Future.delayed(const Duration(seconds: 2), () => emit(BookingInitial()));
         break;
      default:
        // print("Unknown ride status update: $status");
    }
  }

  void _onClearBookingSearch(
    ClearBookingSearch event,
    Emitter<BookingState> emit,
  ) {
    emit(BookingInitial());
  }

   void _onEditRideDetails(
    EditRideDetails event,
    Emitter<BookingState> emit,
  ) {
     // Logic to go back from confirmation/requesting state to search or initial
     // Typically involves emitting BookingInitial or BookingSearchingDestination
     emit(BookingInitial());
  }

  @override
  Future<void> close() {
    // _rideStatusSubscription?.cancel();
    return super.close();
  }
}

