part of 'rating_bloc.dart';


abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

// Event to submit the rating
class SubmitRating extends RatingEvent {
  final String rideId;
  final Map<String, bool> ratings; // e.g., {'politeness': true, 'cleanliness': false}
  final String? comment;

  const SubmitRating({
    required this.rideId,
    required this.ratings,
    this.comment,
  });

  @override
  List<Object> get props => [rideId, ratings, comment ?? ''];
}

