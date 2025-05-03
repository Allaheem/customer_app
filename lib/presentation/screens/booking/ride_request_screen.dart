import 'dart:async';
import 'dart:math';
import 'package:customer_app/presentation/blocs/booking/booking_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// TODO: Import actual BookingBloc, BookingEvent, BookingState
// import '../blocs/booking/booking_bloc.dart';
// TODO: Import actual ActiveRideScreen
// import 'active_ride_screen.dart';

// Placeholder BLoC components - Replace with actual imports
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    // Add dummy handlers if needed for placeholder UI
     on<CancelRideRequested>((event, emit) async {
       print("Bloc received cancel ride request for ${event.rideId}");
       emit(BookingRideCancelled(rideId: event.rideId, reason: "Cancelled by user"));
       await Future.delayed(const Duration(seconds: 1));
       emit(BookingInitial()); // Go back to map
    });
    // Simulate driver assignment and arrival for testing
    Future.delayed(const Duration(seconds: 5), () {
      if (state is BookingFindingDriver) {
        final currentState = state as BookingFindingDriver;
        add(RideStatusUpdated({
          'rideId': currentState.rideId,
          'status': 'driver_assigned',
          'driver': {'name': 'Ahmed Ali', 'vehicle': 'Toyota Camry - White (ABC-123)', 'rating': 4.8},
          'pickupLat': currentState.pickupLatLng.latitude,
          'pickupLng': currentState.pickupLatLng.longitude,
          'driverLat': currentState.pickupLatLng.latitude + 0.01,
          'driverLng': currentState.pickupLatLng.longitude + 0.01,
          'etaPickup': '5 mins',
        }));
      }
    });
     Future.delayed(const Duration(seconds: 15), () {
      if (state is BookingDriverAssigned) {
         final currentState = state as BookingDriverAssigned;
         add(RideStatusUpdated({
          'rideId': currentState.rideId,
          'status': 'driver_arrived',
          'driver': currentState.driverDetails,
          'pickupLat': currentState.pickupLatLng.latitude,
          'pickupLng': currentState.pickupLatLng.longitude,
        }));
      }
    });
  }
}
abstract class BookingEvent extends Equatable { const BookingEvent(); @override List<Object?> get props => []; }

class EditRideDetails extends BookingEvent {
  const EditRideDetails();
}
class CancelRideRequested extends BookingEvent { final String rideId; const CancelRideRequested(this.rideId); @override List<Object?> get props => [rideId]; }
class RideStatusUpdated extends BookingEvent { final dynamic rideUpdateData; const RideStatusUpdated(this.rideUpdateData); @override List<Object?> get props => [rideUpdateData]; }
abstract class BookingState extends Equatable { const BookingState(); @override List<Object?> get props => []; }
class BookingInitial extends BookingState {}
class BookingFindingDriver extends BookingState { final String rideId; final LatLng pickupLatLng; const BookingFindingDriver({required this.rideId, required this.pickupLatLng}); @override List<Object?> get props => [rideId, pickupLatLng]; }
class BookingDriverAssigned extends BookingState { final String rideId; final dynamic driverDetails; final LatLng pickupLatLng; final LatLng driverLatLng; final String etaToPickup; const BookingDriverAssigned({ required this.rideId, required this.driverDetails, required this.pickupLatLng, required this.driverLatLng, required this.etaToPickup }); @override List<Object?> get props => [rideId, driverDetails, pickupLatLng, driverLatLng, etaToPickup]; }
class BookingDriverArrived extends BookingState { final String rideId; final dynamic driverDetails; final LatLng pickupLatLng; const BookingDriverArrived({ required this.rideId, required this.driverDetails, required this.pickupLatLng }); @override List<Object?> get props => [rideId, driverDetails, pickupLatLng]; }
class BookingRideCancelled extends BookingState { final String rideId; final String reason; const BookingRideCancelled({required this.rideId, required this.reason}); @override List<Object?> get props => [rideId, reason]; }
class BookingError extends BookingState { final String message; const BookingError(this.message); @override List<Object?> get props => [message]; }
// End Placeholder BLoC components

// Placeholder Screen for Navigation
class PlaceholderActiveRideScreen extends StatelessWidget {
  final String rideId;
  // TODO: Add necessary parameters like destinationLatLng, initialDriverLatLng
  const PlaceholderActiveRideScreen({super.key, required this.rideId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("On Ride - Placeholder"), automaticallyImplyLeading: false),
      body: Center(child: Text("Starting active ride ID: $rideId")),
    );
  }
}
// End Placeholder Screen

class RideRequestScreen extends StatefulWidget {
  // This screen expects the state to be BookingFindingDriver or BookingDriverAssigned
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  String? _currentRideId;

  @override
  void initState() {
    super.initState();
    // Markers will be built based on BLoC state
  }

  void _buildMapElements(LatLng pickupLatLng, {LatLng? driverLatLng}) {
    _markers.clear();
    // Add Pickup Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup Location / موقع الانطلاق'),
      ),
    );
    // Add Driver Marker if available
    if (driverLatLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: driverLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: const InfoWindow(title: 'Driver / السائق'),
          // TODO: Add rotation based on bearing if available
        ),
      );
    }
    // Fit map to bounds after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCameraToFitMarkers(pickupLatLng, driverLatLng));
  }

  Future<void> _updateCameraToFitMarkers(LatLng pickupLatLng, LatLng? driverLatLng) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds;
    LatLng driverPos = driverLatLng ?? pickupLatLng; // Use pickup if driver not assigned yet

    if (pickupLatLng.latitude >= driverPos.latitude && pickupLatLng.longitude >= driverPos.longitude) {
      bounds = LatLngBounds(southwest: driverPos, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude >= driverPos.longitude) {
      bounds = LatLngBounds(southwest: LatLng(min(pickupLatLng.latitude, driverPos.latitude), driverPos.longitude), northeast: LatLng(max(pickupLatLng.latitude, driverPos.latitude), pickupLatLng.longitude));
    } else if (pickupLatLng.latitude >= driverPos.latitude) {
      bounds = LatLngBounds(southwest: LatLng(driverPos.latitude, min(pickupLatLng.longitude, driverPos.longitude)), northeast: LatLng(pickupLatLng.latitude, max(pickupLatLng.longitude, driverPos.longitude)));
    } else {
      bounds = LatLngBounds(southwest: pickupLatLng, northeast: driverPos);
    }

    // Add padding to ensure markers are not on the edge
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100.0));
  }

  void _cancelRide() {
    if (_currentRideId != null) {
      // Add confirmation dialog (Knowledge ID: user_43)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Cancel Ride / إلغاء الرحلة', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to cancel this ride? / هل أنت متأكد من رغبتك في إلغاء هذه الرحلة؟', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('No / لا', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.read<BookingBloc>().add(CancelRideRequested(_currentRideId!));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Yes, Cancel / نعم، إلغاء', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      // If ride ID is somehow null, just go back
       context.read<BookingBloc>().add(EditRideDetails()); // Or dispatch an appropriate event
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Assuming theme is provided

    return Scaffold(
      appBar: AppBar(
        title: const Text("Waiting for Driver / انتظار السائق"),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          // Handle navigation based on state changes
          if (state is BookingDriverArrived) {
            // Navigate to Active Ride Screen
            Navigator.pushReplacement(
              context,
              // TODO: Use actual ActiveRideScreen and pass necessary data
              MaterialPageRoute(builder: (context) => PlaceholderActiveRideScreen(rideId: state.rideId)),
            );
          } else if (state is BookingInitial || state is BookingRideCancelled) {
             // If state becomes initial or cancelled, pop this screen
             if (ModalRoute.of(context)?.isCurrent ?? false) {
                Navigator.pop(context);
             }
          } else if (state is BookingError) {
             ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.redAccent));
          }
        },
        builder: (context, state) {
          String statusMessage = "Connecting... / جاري الاتصال...";
          String? driverName;
          String? vehicleDetails;
          String? driverEta;
          bool showLoadingIndicator = true;
          LatLng? pickupLatLng;
          LatLng? driverLatLng;

          if (state is BookingFindingDriver) {
            statusMessage = "Finding your driver... / جاري البحث عن سائق...";
            _currentRideId = state.rideId;
            pickupLatLng = state.pickupLatLng;
            _buildMapElements(pickupLatLng);
          } else if (state is BookingDriverAssigned) {
            statusMessage = "Driver found! / تم العثور على سائق!";
            _currentRideId = state.rideId;
            // TODO: Extract details from state.driverDetails model
            driverName = state.driverDetails?['name'] ?? 'Driver';
            vehicleDetails = state.driverDetails?['vehicle'] ?? 'Vehicle';
            driverEta = state.etaToPickup;
            pickupLatLng = state.pickupLatLng;
            driverLatLng = state.driverLatLng;
            showLoadingIndicator = false;
             _buildMapElements(pickupLatLng, driverLatLng: driverLatLng);
          } else if (state is BookingDriverArrived) {
             // This state is brief, listener handles navigation
             statusMessage = "Driver has arrived! / السائق وصل!";
             _currentRideId = state.rideId;
             driverName = state.driverDetails?['name'] ?? 'Driver';
             vehicleDetails = state.driverDetails?['vehicle'] ?? 'Vehicle';
             driverEta = "Arrived / وصل";
             pickupLatLng = state.pickupLatLng;
             driverLatLng = state.pickupLatLng; // Driver is at pickup
             showLoadingIndicator = false;
             _buildMapElements(pickupLatLng, driverLatLng: driverLatLng);
          } else {
             // Handle unexpected states (e.g., BookingInitial, BookingError already handled by listener)
             // If we reach here unexpectedly, pop back.
             WidgetsBinding.instance.addPostFrameCallback((_) {
               if (ModalRoute.of(context)?.isCurrent ?? false) {
                  Navigator.pop(context);
               }
            });
             return const Center(child: Text('Invalid State / حالة غير متوقعة', style: TextStyle(color: Colors.red)));
          }

          return Column(
            children: [
              // --- Map View ---
              Expanded(
                flex: 3,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: pickupLatLng ?? const LatLng(24.7136, 46.6753), // Default if null
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                     if (!_controller.isCompleted) {
                       _controller = Completer(); // Reset completer
                       _controller.complete(controller);
                     }
                     // Fit markers after map is created
                     _updateCameraToFitMarkers(pickupLatLng!, driverLatLng);
                  },
                  markers: _markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  padding: const EdgeInsets.only(bottom: 250), // Padding for the bottom sheet
                ),
              ),

              // --- Status & Driver Info Sheet ---
              Container(
                height: 280,
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20) ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      statusMessage,
                      style: TextStyle(color: Colors.amber[700], fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (!showLoadingIndicator && driverName != null)
                      Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber[700],
                              child: const Icon(Icons.person, color: Colors.black),
                            ),
                            title: Text(driverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text(vehicleDetails ?? '', style: const TextStyle(color: Colors.grey)),
                            // TODO: Add driver rating display from driverDetails
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Estimated Arrival / الوصول المقدر: ${driverEta ?? '...'}",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )
                    else
                       const Padding(
                         padding: EdgeInsets.symmetric(vertical: 20.0),
                         child: CircularProgressIndicator(color: Colors.amber),
                       ),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _cancelRide,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("Cancel Ride / إلغاء الرحلة"),
                      ),
                    ),
                    // TODO: Add buttons for Chat/Call (Step 013)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

