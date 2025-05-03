import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Import actual MapBloc, MapEvent, MapState
// TODO: Import actual SearchDestinationScreen
// TODO: Import actual RideRequestScreen
// TODO: Import actual UserSettings/Profile info for avatar

// Placeholder BLoC components
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapLoading()) {
    on<LoadMapData>((event, emit) async {
      emit(MapLoading());
      await Future.delayed(const Duration(seconds: 1));
      // Simulate loading user location and nearby drivers
      emit(MapLoaded(
        userLocation: const LatLng(37.7749, -122.4194), // Example: San Francisco
        nearbyDrivers: {
          Marker(
            markerId: const MarkerId('driver1'),
            position: const LatLng(37.7759, -122.4184),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: const InfoWindow(title: 'Driver 1 / سائق 1'),
          ),
          Marker(
            markerId: const MarkerId('driver2'),
            position: const LatLng(37.7739, -122.4204),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: const InfoWindow(title: 'Driver 2 / سائق 2'),
          ),
        },
      ));
    });
  }
}
abstract class MapEvent extends Equatable { const MapEvent(); @override List<Object?> get props => []; }
class LoadMapData extends MapEvent {}
abstract class MapState extends Equatable { const MapState(); @override List<Object?> get props => []; }
class MapLoading extends MapState {}
class MapLoaded extends MapState {
  final LatLng userLocation;
  final Set<Marker> nearbyDrivers;
  MapLoaded({required this.userLocation, required this.nearbyDrivers});
  @override List<Object?> get props => [userLocation, nearbyDrivers];
}
class MapError extends MapState { final String message; const MapError(this.message); @override List<Object?> get props => [message]; }
// End Placeholder BLoC components

// Placeholder Screens
class PlaceholderSearchDestinationScreen extends StatelessWidget {
  const PlaceholderSearchDestinationScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Search Destination - Placeholder")), body: const Center(child: Text("Search Form")));
}
class PlaceholderRideRequestScreen extends StatelessWidget {
  final LatLng pickup; final LatLng destination; final String destinationName;
  const PlaceholderRideRequestScreen({super.key, required this.pickup, required this.destination, required this.destinationName});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Request Ride - Placeholder")), body: Center(child: Text("Requesting ride to $destinationName")));
}
// End Placeholder Screens

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentUserLocation;

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch LoadMapData event
    // context.read<MapBloc>().add(LoadMapData());
    // Simulate loading for placeholder
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentUserLocation = const LatLng(37.7749, -122.4194);
        });
        _updateCameraPosition(_currentUserLocation!);
      }
    });
  }

  Future<void> _updateCameraPosition(LatLng target) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: 14.0),
    ));
  }

  void _navigateToSearch() async {
    // TODO: Navigate to actual SearchDestinationScreen
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const SearchDestinationScreen()),
    // );
    // Simulate search result
    final result = {
      'destinationName': 'Example Destination',
      'destinationLatLng': const LatLng(37.7849, -122.4294),
    };

    if (result != null && _currentUserLocation != null) {
      // TODO: Navigate to actual RideRequestScreen/ConfirmationScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceholderRideRequestScreen(
          pickup: _currentUserLocation!,
          destination: result['destinationLatLng'] as LatLng,
          destinationName: result['destinationName'] as String,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Taxi Ai"),
        backgroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 22, fontWeight: FontWeight.bold),
        centerTitle: true,
        // TODO: Add Drawer or Profile icon
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.amber[700]),
          tooltip: 'Open Menu / فتح القائمة', // Accessibility Step 018
          onPressed: () { /* TODO: Open drawer */ },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.amber[700],
              // TODO: Replace with user image if available
              child: const Icon(Icons.person, color: Colors.black),
              // Accessibility Step 018: Add semantic label for avatar
              // Use Semantics widget if the CircleAvatar itself doesn't support it directly
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map View
          BlocBuilder<MapBloc, MapState>(
            // TODO: Use actual MapBloc
            builder: (context, state) {
              Set<Marker> markers = {};
              CameraPosition initialCameraPosition = const CameraPosition(
                target: LatLng(0, 0), // Default location
                zoom: 1,
              );

              if (state is MapLoaded) {
                _currentUserLocation = state.userLocation;
                initialCameraPosition = CameraPosition(
                  target: state.userLocation,
                  zoom: 14.0,
                );
                markers = state.nearbyDrivers;                // Add user marker (Avatar on map - Knowledge ID: user_49)
                markers.add(
                  Marker(                   markerId: const MarkerId('userLocation'),
                    position: state.userLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    infoWindow: const InfoWindow(title: 'Your Location / موقعك'),
                    // TODO: Use custom avatar icon if available
                  ),
                );
              } else if (_currentUserLocation != null) {
                 // Use simulated location if state isn't loaded yet
                 initialCameraPosition = CameraPosition(
                  target: _currentUserLocation!,
                  zoom: 14.0,
                );
                 markers.add(
                  Marker(
                    markerId: const MarkerId('userLocation'),
                    position: _currentUserLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    infoWindow: const InfoWindow(title: 'Your Location / موقعك'),
                  ),
                );
              }

              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                  // Apply custom map style (dark theme)
                  // controller.setMapStyle(_mapStyleJson);
                },
                markers: markers,
                myLocationEnabled: false, // Using custom marker instead
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                padding: const EdgeInsets.only(bottom: 100), // Padding for the search bar
                // Accessibility Step 018: Add semantic description for the map
                // This might require wrapping GoogleMap in a Semantics widget
              );
            },
          ),
          // Loading Indicator
          BlocBuilder<MapBloc, MapState>(
             // TODO: Use actual MapBloc
             builder: (context, state) {
                if (state is MapLoading) {
                   return const Center(child: CircularProgressIndicator(color: Colors.amber));
                }
                return const SizedBox.shrink(); // Hide if not loading
             }
          ),

          // Search Bar Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Accessibility Step 018: Wrap the search input in Semantics
                  Semantics(
                    label: 'Search for destination input field / حقل البحث عن وجهة',
                    hint: 'Tap to search for a destination / انقر للبحث عن وجهة',
                    button: true, // Indicate it acts like a button
                    child: InkWell(
                      onTap: _navigateToSearch,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey[700]!)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.amber[700]),
                            const SizedBox(width: 10),
                            Text(
                              'Where to? / إلى أين؟',
                              style: TextStyle(color: Colors.grey[400], fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // TODO: Add saved locations/shortcuts here?
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

