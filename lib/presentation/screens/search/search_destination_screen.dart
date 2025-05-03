import 'dart:async'; // Import dart:async for Timer
import 'package:equatable/equatable.dart'; // Import Equatable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Needed for LatLng

// TODO: Import actual BookingBloc, BookingEvent, BookingState
// import '../blocs/booking/booking_bloc.dart';
// import '../blocs/booking/booking_event.dart';
// import '../blocs/booking/booking_state.dart';

// Placeholder BLoC components for UI building - Replace with actual imports
abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class DestinationSearchQueryChanged extends BookingEvent {
  final String query;
  const DestinationSearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class DestinationSelected extends BookingEvent {
  final String placeId;
  final String description;
  const DestinationSelected({required this.placeId, required this.description});
  @override
  List<Object?> get props => [placeId, description];
}

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingSearchingDestination extends BookingState {}

class BookingDestinationSearchResultsLoaded extends BookingState {
  final List<dynamic> predictions;
  const BookingDestinationSearchResultsLoaded(this.predictions);
  @override
  List<Object?> get props => [predictions];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<DestinationSearchQueryChanged>((event, emit) async {
      print("Bloc received search query: ${event.query}");
      emit(BookingSearchingDestination());
      await Future.delayed(const Duration(milliseconds: 300));
      if (event.query.isNotEmpty) {
        emit(BookingDestinationSearchResultsLoaded([
          {'id': 'place_1', 'description': '${event.query} Result 1 - Placeholder'},
          {'id': 'place_2', 'description': '${event.query} Result 2 - Placeholder'},
        ]));
      } else {
        emit(BookingInitial());
      }
    });
    on<DestinationSelected>((event, emit) async {
      print("Bloc received place selection: ${event.description}");
      // In a real app, this might trigger fetching place details
      // For now, just acknowledge
      emit(BookingInitial()); // Go back to initial state after selection (for placeholder)
    });
  }
}
// End Placeholder BLoC components

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Dispatch event to BLoC after user stops typing
      // TODO: Use actual BookingBloc
      context.read<BookingBloc>().add(DestinationSearchQueryChanged(query));
    });
  }

  void _onPlaceSelected(String placeId, String description) {
    // Dispatch event to BLoC
    // TODO: Use actual BookingBloc
    // context.read<BookingBloc>().add(DestinationSelected(placeId: placeId, description: description));
    print("Place selected: $description (ID: $placeId)");
    // Navigate back with the selected result
    // The actual LatLng might be fetched here or passed back
    Navigator.pop(context, {
      'destinationName': description,
      // 'destinationLatLng': fetchedLatLng, // TODO: Fetch LatLng based on placeId if needed
      'destinationLatLng': const LatLng(37.7849, -122.4294) // Placeholder LatLng
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Inherit or define the Black/Gold theme (Knowledge ID: user_19, user_41)
    // final ThemeData theme = Theme.of(context); // Assuming theme is provided higher up

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Theme color
        iconTheme: IconThemeData(color: Colors.amber[700]), // Theme color
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search destination / البحث عن وجهة...', // Placeholder
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      backgroundColor: Colors.black, // Theme color
      body: BlocBuilder<BookingBloc, BookingState>(
        // TODO: Use actual BookingBloc
        builder: (context, state) {
          if (state is BookingSearchingDestination) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
          if (state is BookingDestinationSearchResultsLoaded) {
            if (state.predictions.isEmpty) {
              return const Center(
                child: Text('No results found / لم يتم العثور على نتائج', style: TextStyle(color: Colors.grey)),
              );
            }
            return ListView.builder(
              itemCount: state.predictions.length,
              itemBuilder: (context, index) {
                final prediction = state.predictions[index];
                final placeId = prediction['id'] as String; // Placeholder access
                final description = prediction['description'] as String; // Placeholder access

                return ListTile(
                  leading: Icon(Icons.location_on, color: Colors.amber[700]), // Theme color
                  title: Text(description, style: const TextStyle(color: Colors.white)),
                  // subtitle: Text('Secondary text', style: TextStyle(color: Colors.grey[400])), // Optional
                  onTap: () => _onPlaceSelected(placeId, description),
                  // TODO: Add animation on tap (Knowledge ID: user_47)
                );
              },
            );
          }
          if (state is BookingError) {
            return Center(
              child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)),
            );
          }
          // Initial or other states - show nothing or a prompt
          return const Center(
            child: Text('Start typing to search / ابدأ الكتابة للبحث', style: TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }
}

