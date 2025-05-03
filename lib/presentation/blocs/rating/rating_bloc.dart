import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// TODO: Import RatingRepository

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  // TODO: Inject RatingRepository
  // final RatingRepository _ratingRepository;

  RatingBloc(/* required this._ratingRepository */) : super(RatingInitial()) {
    on<SubmitRating>(_onSubmitRating);
  }

  Future<void> _onSubmitRating(
    SubmitRating event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingSubmitting());
    try {
      // TODO: Call _ratingRepository.submitRating(
      //   rideId: event.rideId,
      //   ratings: event.ratings,
      //   comment: event.comment,
      // );
      // print("Submitting rating via repository for ride ${event.rideId}: ${event.ratings}, Comment: ${event.comment}"); // Removed print statement
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      emit(RatingSuccess(event.rideId));

      // Optionally reset state after a delay if needed
      // await Future.delayed(const Duration(seconds: 2));
      // emit(RatingInitial());

    } catch (e) {
      emit(RatingError("Failed to submit rating: ${e.toString()}"));
    }
  }
}

