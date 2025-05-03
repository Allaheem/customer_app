import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Import actual BookingBloc, BookingEvent, BookingState
// import '../blocs/booking/booking_bloc.dart';
// TODO: Import actual RideRequestScreen
// import 'ride_request_screen.dart';
// TODO: Import actual PaymentOptionsScreen
// import '../payment/payment_options_screen.dart';

// Placeholder BLoC components
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<ConfirmRideDetails>((event, emit) async {
      emit(BookingDetailsConfirmed(
        pickupLatLng: event.pickupLatLng,
        destinationLatLng: event.destinationLatLng,
        destinationName: event.destinationName,
        estimatedFare: {'amount': 25.50, 'currency': 'SAR'}, // Dummy fare
        estimatedEta: '10 mins',
        availableVehicleTypes: ['Standard', 'XL', 'Luxury', 'WAV'], // Added WAV (Step 018)
      ));
    });
    on<RequestRide>((event, emit) async {
      // print("Bloc received ride request: Pickup=${event.pickupLatLng}, Dest=${event.destinationLatLng}, Type=${event.vehicleType}, WAV=${event.needsWAV}");
      emit(BookingRideRequested(rideId: 'ride_${DateTime.now().millisecondsSinceEpoch}'));
    });
     on<CancelRideRequest>((event, emit) async {
       // print("Bloc received cancel ride request for ${event.rideId}");
       emit(BookingRideCancelled(rideId: event.rideId, reason: "Cancelled by user before confirmation"));
       await Future.delayed(const Duration(seconds: 1));
       emit(BookingInitial()); // Go back to map
    });
  }
}
abstract class BookingEvent extends Equatable { const BookingEvent(); @override List<Object?> get props => []; }
class ConfirmRideDetails extends BookingEvent { final LatLng pickupLatLng; final LatLng destinationLatLng; final String destinationName; const ConfirmRideDetails({required this.pickupLatLng, required this.destinationLatLng, required this.destinationName}); @override List<Object?> get props => [pickupLatLng, destinationLatLng, destinationName]; }
class RequestRide extends BookingEvent { final LatLng pickupLatLng; final LatLng destinationLatLng; final String vehicleType; final bool needsWAV; const RequestRide({required this.pickupLatLng, required this.destinationLatLng, required this.vehicleType, required this.needsWAV}); @override List<Object?> get props => [pickupLatLng, destinationLatLng, vehicleType, needsWAV]; }
class CancelRideRequest extends BookingEvent { final String rideId; const CancelRideRequest(this.rideId); @override List<Object?> get props => [rideId]; }
abstract class BookingState extends Equatable { const BookingState(); @override List<Object?> get props => []; }
class BookingInitial extends BookingState {}
class BookingDetailsConfirmed extends BookingState { final LatLng pickupLatLng; final LatLng destinationLatLng; final String destinationName; final dynamic estimatedFare; final String estimatedEta; final List<String> availableVehicleTypes; const BookingDetailsConfirmed({ required this.pickupLatLng, required this.destinationLatLng, required this.destinationName, required this.estimatedFare, required this.estimatedEta, required this.availableVehicleTypes }); @override List<Object?> get props => [pickupLatLng, destinationLatLng, destinationName, estimatedFare, estimatedEta, availableVehicleTypes]; }
class BookingRideRequested extends BookingState { final String rideId; const BookingRideRequested({required this.rideId}); @override List<Object?> get props => [rideId]; }
class BookingRideCancelled extends BookingState { final String rideId; final String reason; const BookingRideCancelled({required this.rideId, required this.reason}); @override List<Object?> get props => [rideId, reason]; }
class BookingError extends BookingState { final String message; const BookingError(this.message); @override List<Object?> get props => [message]; }
// End Placeholder BLoC components

// Placeholder Screens
class PlaceholderRideRequestScreen extends StatelessWidget { final String rideId; const PlaceholderRideRequestScreen({super.key, required this.rideId}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Requesting Ride - Placeholder")), body: Center(child: Text("Waiting for driver... Ride ID: $rideId"))); }
class PlaceholderPaymentOptionsScreen extends StatelessWidget { const PlaceholderPaymentOptionsScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Payment Options - Placeholder")), body: const Center(child: Text("Payment Methods"))); }
// End Placeholder Screens

class RideConfirmationScreen extends StatefulWidget {
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;
  final String destinationName;

  const RideConfirmationScreen({
    super.key,
    required this.pickupLatLng,
    required this.destinationLatLng,
    required this.destinationName,
  });

  @override
  State<RideConfirmationScreen> createState() => _RideConfirmationScreenState();
}

class _RideConfirmationScreenState extends State<RideConfirmationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String? _selectedVehicleType; // e.g., 'Standard', 'XL'
  bool _needsWheelchairAccess = false; // Accessibility Step 018 (Knowledge ID: user_20)

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to get ride details (fare, eta, vehicle types)
    // context.read<BookingBloc>().add(ConfirmRideDetails(
    //   pickupLatLng: widget.pickupLatLng,
    //   destinationLatLng: widget.destinationLatLng,
    //   destinationName: widget.destinationName,
    // ));
    // Simulate loading details
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
         // Simulate receiving details
         context.read<BookingBloc>().add(ConfirmRideDetails(
            pickupLatLng: widget.pickupLatLng,
            destinationLatLng: widget.destinationLatLng,
            destinationName: widget.destinationName,
         ));
      }
    });
  }

  Future<void> _updateMapToBounds(LatLng pickup, LatLng destination) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds;

    if (pickup.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: destination, northeast: pickup);
    } else {
      bounds = LatLngBounds(southwest: pickup, northeast: destination);
    }

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0)); // 50 padding
  }

  void _confirmAndRequestRide(String vehicleType) {
    // TODO: Dispatch RequestRide event
    context.read<BookingBloc>().add(RequestRide(
      pickupLatLng: widget.pickupLatLng,
      destinationLatLng: widget.destinationLatLng,
      vehicleType: vehicleType,
      needsWAV: _needsWheelchairAccess, // Pass WAV requirement (Step 018)
    ));
  }

  Widget _buildVehicleTypeSelector(List<String> types, dynamic estimatedFare) {
    // Filter types based on WAV requirement if needed (or handle in backend)
    List<String> availableTypes = types;
    if (_needsWheelchairAccess) {
      // Only show types that support WAV (assuming 'WAV' is a specific type)
      // Or, this could be a flag sent with any type request.
      // For simplicity here, let's assume 'WAV' is the only option if selected.
      if (types.contains('WAV')) {
         availableTypes = ['WAV'];
         if (_selectedVehicleType != 'WAV') {
            _selectedVehicleType = 'WAV'; // Auto-select WAV if needed
         }
      } else {
         // No WAV available - show message?
         return const Center(child: Text("No wheelchair accessible vehicles available for this route.", style: TextStyle(color: Colors.orangeAccent)));
      }
    }

    // Default selection if none chosen or previous selection invalid
    if (_selectedVehicleType == null || !availableTypes.contains(_selectedVehicleType)) {
      _selectedVehicleType = availableTypes.isNotEmpty ? availableTypes.first : null;
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableTypes.length,
        itemBuilder: (context, index) {
          final type = availableTypes[index];
          final isSelected = type == _selectedVehicleType;
          // TODO: Get specific icons and fare adjustments per type
          IconData icon = type == 'XL' ? Icons.people_alt_outlined
                        : type == 'Luxury' ? Icons.star_outline
                        : type == 'WAV' ? Icons.accessible_forward // Step 018
                        : Icons.local_taxi_outlined;
          double fareMultiplier = type == 'XL' ? 1.5 : type == 'Luxury' ? 2.0 : 1.0;
          String displayFare = estimatedFare != null
              ? "${(estimatedFare['amount'] * fareMultiplier).toStringAsFixed(2)} ${estimatedFare['currency']}"
              : "--";

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedVehicleType = type;
              });
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber[700] : Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isSelected ? Colors.black : Colors.grey[700]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: isSelected ? Colors.black : Colors.amber[700], size: 30),
                  const SizedBox(height: 5),
                  Text(type, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                  Text(displayFare, style: TextStyle(color: isSelected ? Colors.black87 : Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Ride / تأكيد الرحلة"),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingRideRequested) {
            // Navigate to Ride Request Screen (waiting for driver)
            Navigator.pushReplacement(
              context,
              // TODO: Use actual RideRequestScreen
              MaterialPageRoute(builder: (context) => PlaceholderRideRequestScreen(rideId: state.rideId)),
            );
          } else if (state is BookingError) {
             ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.redAccent));
          }
        },
        builder: (context, state) {
          if (state is BookingDetailsConfirmed) {
            // Update map bounds once details are confirmed
            WidgetsBinding.instance.addPostFrameCallback((_) => _updateMapToBounds(widget.pickupLatLng, widget.destinationLatLng));

            return Column(
              children: [
                // Map Preview
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: widget.pickupLatLng, // Center between pickup and dest?
                      zoom: 12,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                         _controller.complete(controller);
                      }
                      _updateMapToBounds(widget.pickupLatLng, widget.destinationLatLng);
                    },
                    markers: {
                      Marker(markerId: const MarkerId('pickup'), position: widget.pickupLatLng, infoWindow: const InfoWindow(title: 'Pickup / الانطلاق')),
                      Marker(markerId: const MarkerId('destination'), position: widget.destinationLatLng, infoWindow: InfoWindow(title: 'Destination / الوجهة: ${widget.destinationName}')),
                    },
                    polylines: {
                       // TODO: Add actual route polyline if available
                       Polyline(
                         polylineId: const PolylineId('route_preview'),
                         points: [widget.pickupLatLng, widget.destinationLatLng],
                         color: Colors.amber[700]!,
                         width: 3,
                       )
                    },
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                ),

                // Ride Details & Confirmation Panel
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Select Vehicle Type / اختر نوع المركبة',
                        style: TextStyle(color: Colors.amber[700], fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      _buildVehicleTypeSelector(state.availableVehicleTypes, state.estimatedFare),
                      const SizedBox(height: 15),
                      // Accessibility Option (Step 018 - Knowledge ID: user_20)
                      SwitchListTile(
                         title: const Text("Wheelchair Accessible Vehicle / مركبة متاحة للكراسي المتحركة", style: TextStyle(color: Colors.white)),
                         value: _needsWheelchairAccess,
                         onChanged: (bool value) {
                           setState(() {
                             _needsWheelchairAccess = value;
                             // If WAV is selected, ensure the vehicle type updates
                             if (value && state.availableVehicleTypes.contains('WAV')) {
                               _selectedVehicleType = 'WAV';
                             } else if (!value && _selectedVehicleType == 'WAV') {
                               // If WAV deselected, revert to default/first type
                               _selectedVehicleType = state.availableVehicleTypes.isNotEmpty ? state.availableVehicleTypes.first : null;
                             }
                           });
                         },
                         secondary: Icon(Icons.accessible_forward, color: Colors.amber[700]),
                         activeColor: Colors.amber[700],
                         inactiveTrackColor: Colors.grey[700],
                         tileColor: Colors.grey[850],
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         // Only enable if WAV type is available?
                         // enabled: state.availableVehicleTypes.contains('WAV'),
                      ),
                      const SizedBox(height: 15),
                      // Payment Method
                      ListTile(
                        leading: Icon(Icons.payment, color: Colors.amber[700]),
                        title: const Text("Payment / الدفع", style: TextStyle(color: Colors.white)),
                        subtitle: Text("Cash / نقداً (Default)", style: TextStyle(color: Colors.grey[400])), // TODO: Show actual selected method
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
                        onTap: () {
                          // TODO: Navigate to Payment Options Screen
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderPaymentOptionsScreen()));
                        },
                        tileColor: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Button
                      ElevatedButton(
                        onPressed: _selectedVehicleType == null ? null : () => _confirmAndRequestRide(_selectedVehicleType!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: Text('Confirm Ride / تأكيد الرحلة (${state.estimatedEta})'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Show Loading or Initial State
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
        },
      ),
    );
  }
}

