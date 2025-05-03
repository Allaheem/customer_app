part of 'rating_bloc.dart';


abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

// Initial state before any submission
class RatingInitial extends RatingState {}

// State while the rating is being submitted
class RatingSubmitting extends RatingState {}

// State after successful submission
class RatingSuccess extends RatingState {
  final String rideId;

  const RatingSuccess(this.rideId);

  @override
  List<Object> get props => [rideId];
}

// State if an error occurs during submission
class RatingError extends RatingState {
  final String message;

  const RatingError(this.message);

  @override
  List<Object> get props => [message];
}

