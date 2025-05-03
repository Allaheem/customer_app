import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math'; // For min/max in LatLngBounds

// TODO: Import actual BookingBloc, BookingEvent, BookingState
// import '../blocs/booking/booking_bloc.dart';
// TODO: Import actual RatingScreen
// import '../rating/rating_screen.dart';
// TODO: Import ChatScreen
// import '../chat/chat_screen.dart';

// Placeholder BLoC components - Replace with actual imports
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    // Add dummy handlers if needed for placeholder UI
    on<CancelRideRequested>((event, emit) async {
       // print("Bloc received cancel ride request for ${event.rideId} (during active ride - less common)");
       emit(BookingRideCancelled(rideId: event.rideId, reason: "Cancelled by user during ride"));
       await Future.delayed(const Duration(seconds: 1));
       emit(BookingInitial()); // Go back to map
    });
    // Simulate ride progress for testing
    Future.delayed(const Duration(seconds: 5), () {
      if (state is BookingDriverArrived) { // Assuming previous state was DriverArrived
         final currentState = state as BookingDriverArrived;
         add(RideStatusUpdated({
          'rideId': currentState.rideId,
          'status': 'ride_started',
          'driver': currentState.driverDetails,
          'driverLat': currentState.pickupLatLng.latitude,
          'driverLng': currentState.pickupLatLng.longitude,
          'destLat': currentState.pickupLatLng.latitude + 0.03, // Dummy destination
          'destLng': currentState.pickupLatLng.longitude + 0.03,
          'etaDest': '15 mins',
        }));
      }
    });
     Future.delayed(const Duration(seconds: 20), () {
      if (state is BookingRideActive) {
         final currentState = state as BookingRideActive;
         add(RideStatusUpdated({
          'rideId': currentState.rideId,
          'status': 'ride_completed',
          'finalFare': {'amount': 30.0, 'currency': 'SAR'},
        }));
      }
    });
  }
}
abstract class BookingEvent extends Equatable { const BookingEvent(); @override List<Object?> get props => []; }
class CancelRideRequested extends BookingEvent { final String rideId; const CancelRideRequested(this.rideId); @override List<Object?> get props => [rideId]; }
class RideStatusUpdated extends BookingEvent { final dynamic rideUpdateData; const RideStatusUpdated(this.rideUpdateData); @override List<Object?> get props => [rideUpdateData]; }
abstract class BookingState extends Equatable { const BookingState(); @override List<Object?> get props => []; }
class BookingInitial extends BookingState {}
class BookingDriverArrived extends BookingState { final String rideId; final dynamic driverDetails; final LatLng pickupLatLng; const BookingDriverArrived({ required this.rideId, required this.driverDetails, required this.pickupLatLng }); @override List<Object?> get props => [rideId, driverDetails, pickupLatLng]; }
class BookingRideActive extends BookingState { final String rideId; final dynamic driverDetails; final LatLng driverLatLng; final LatLng destinationLatLng; final String etaToDestination; const BookingRideActive({ required this.rideId, required this.driverDetails, required this.driverLatLng, required this.destinationLatLng, required this.etaToDestination }); @override List<Object?> get props => [rideId, driverDetails, driverLatLng, destinationLatLng, etaToDestination]; }
class BookingRideCompleted extends BookingState { final String rideId; final dynamic finalFare; const BookingRideCompleted({required this.rideId, this.finalFare}); @override List<Object?> get props => [rideId, finalFare]; }
class BookingRideCancelled extends BookingState { final String rideId; final String reason; const BookingRideCancelled({required this.rideId, required this.reason}); @override List<Object?> get props => [rideId, reason]; }
class BookingError extends BookingState { final String message; const BookingError(this.message); @override List<Object?> get props => [message]; }
// End Placeholder BLoC components

// Placeholder Screen for Navigation
class PlaceholderRatingScreen extends StatelessWidget {
  final String rideId;
  final dynamic finalFare;
  const PlaceholderRatingScreen({super.key, required this.rideId, this.finalFare});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Ride - Placeholder"), automaticallyImplyLeading: false),
      body: Center(child: Text("Rate ride ID: $rideId. Final Fare: ${finalFare?['amount']} ${finalFare?['currency']}")),
    );
  }
}
// End Placeholder Screen

class ActiveRideScreen extends StatefulWidget {
  // This screen expects the state to be BookingRideActive
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _currentRideId;
  bool _isBlackBoxRecording = false; // State for Digital Black Box (Step 014)

  @override
  void initState() {
    super.initState();
    // Markers and polylines will be built based on BLoC state
  }

  void _buildMapElements(LatLng driverLatLng, LatLng destinationLatLng, {String? polylinePoints}) {
    _markers.clear();
    _polylines.clear();

    // Add Driver Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'Driver / السائق'),
        // TODO: Add rotation based on bearing if available from state
      ),
    );
    // Add Destination Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Destination / الوجهة'),
      ),
    );

    // TODO: Decode polyline from actual route data (polylinePoints)
    // Placeholder polyline
    List<LatLng> polylineCoordinates = [ driverLatLng, destinationLatLng ];
    Polyline polyline = Polyline(
      polylineId: const PolylineId('active_route'),
      color: Colors.amber[700]!, // Theme color
      points: polylineCoordinates,
      width: 5,
    );
    _polylines.add(polyline);

    // Update camera to follow driver
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCameraToFollowDriver(driverLatLng));
  }

  Future<void> _updateCameraToFollowDriver(LatLng driverLatLng) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: driverLatLng,
        zoom: 16.0, // Keep zoomed in on the driver
        // TODO: Consider adding tilt and bearing from state
      ),
    ));
  }

  void _shareRideStatus() {
    // TODO: Implement ride status sharing functionality using data from state
    // print("Share ride status tapped for ride: $_currentRideId");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing ride status... / جاري مشاركة حالة الرحلة...')), // Placeholder
    );
  }

  void _emergencySOS() {
    // TODO: Implement SOS functionality
    // print("SOS button tapped for ride: $_currentRideId");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Confirm SOS / تأكيد طلب المساعدة', style: TextStyle(color: Colors.redAccent)),
        content: const Text('Are you sure you want to trigger the emergency SOS? This will alert emergency contacts and authorities. / هل أنت متأكد من رغبتك في تفعيل طلب المساعدة الطارئة؟ سيؤدي هذا إلى تنبيه جهات الاتصال والطوارئ.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel / إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Trigger actual SOS logic (dispatch event?)
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SOS Activated! Authorities notified. / تم تفعيل طلب المساعدة! تم إبلاغ السلطات.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Confirm SOS / تأكيد الطلب', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleBlackBoxRecording() {
    // TODO: Implement actual recording start/stop logic with encryption
    // Consider user_22: Encrypted on device, driver decrypts.
    // Customer app might only send a request to driver app or backend to start/stop.
    setState(() {
      _isBlackBoxRecording = !_isBlackBoxRecording;
    });
    // print("Digital Black Box Recording (Customer Request): ${_isBlackBoxRecording ? 'Requested Start' : 'Requested Stop'}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Digital Black Box: ${_isBlackBoxRecording ? 'Recording Requested / تم طلب التسجيل' : 'Stop Recording Requested / تم طلب إيقاف التسجيل'}"))
    );
    // TODO: Dispatch event to BLoC/Repository to signal recording request
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Assuming theme is provided

    return Scaffold(
      appBar: AppBar(
        title: const Text("On Ride / في رحلة"),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          // Handle navigation based on state changes
          if (state is BookingRideCompleted) {
            // Navigate to Payment/Rating Screen
            // TODO: Navigate to RidePaymentScreen (Step 012) first
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PlaceholderRatingScreen(rideId: state.rideId, finalFare: state.finalFare)),
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
          if (state is BookingRideActive) {
            _currentRideId = state.rideId;
            // TODO: Extract details from state.driverDetails model
            final String driverName = state.driverDetails?['name'] ?? 'Driver';
            final String vehicleDetails = state.driverDetails?['vehicle'] ?? 'Vehicle';
            final String eta = state.etaToDestination;
            // TODO: Get destination address from state if available, or pass from previous screen
            final String destinationAddress = "Destination Address Placeholder";

            _buildMapElements(state.driverLatLng, state.destinationLatLng);

            return Column(
              children: [
                // --- Map View ---
                Expanded(
                  flex: 3,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: state.driverLatLng,
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                       if (!_controller.isCompleted) {
                         _controller = Completer(); // Reset completer
                         _controller.complete(controller);
                       }
                       // Fit route after map is created
                       _updateCameraToFollowDriver(state.driverLatLng);
                    },
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    padding: const EdgeInsets.only(bottom: 250), // Adjusted Padding for the bottom sheet
                  ),
                ),

                // --- Ride Details & Controls Sheet ---
                Container(
                  height: 280, // Increased height to accommodate new button
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20) ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Destination & ETA
                      Column(
                        children: [
                          Text(
                            "Destination / الوجهة: $destinationAddress",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Est. Arrival / الوصول المقدر: $eta",
                            style: TextStyle(color: Colors.amber[700], fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // Driver Info
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber[700],
                          child: const Icon(Icons.person, color: Colors.black),
                        ),
                        title: Text(driverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(vehicleDetails, style: const TextStyle(color: Colors.grey)),
                        // TODO: Add driver rating display from driverDetails
                      ),

                      // Safety & Communication Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Share Ride
                          ElevatedButton.icon(
                            onPressed: _shareRideStatus,
                            icon: const Icon(Icons.share, size: 18),
                            label: const Text("Share / مشاركة"),
                            style: ElevatedButton.styleFrom( backgroundColor: Colors.blueGrey[700], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8) ),
                          ),
                          // SOS
                          ElevatedButton.icon(
                            onPressed: _emergencySOS,
                            icon: const Icon(Icons.sos, size: 18),
                            label: const Text("SOS"),
                            style: ElevatedButton.styleFrom( backgroundColor: Colors.redAccent[700], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8) ),
                          ),
                          // Chat
                          ElevatedButton.icon(
                            onPressed: () { /* TODO: Navigate to ChatScreen (Step 013) */ print("Chat tapped"); },
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text("Chat / محادثة"),
                            style: ElevatedButton.styleFrom( backgroundColor: Colors.teal[700], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8) ),
                          ),
                        ],
                      ),
                      // Digital Black Box Toggle (Step 014)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _toggleBlackBoxRecording,
                          icon: Icon(_isBlackBoxRecording ? Icons.videocam_off : Icons.videocam, size: 18),
                          label: Text(_isBlackBoxRecording ? "Stop Recording / إيقاف التسجيل" : "Start Recording / بدء التسجيل"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isBlackBoxRecording ? Colors.redAccent[700] : Colors.blueGrey[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Show loading or handle other states
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
        },
      ),
    );
  }
}

