import 'package:equatable/equatable.dart';
import 'package:hatley/domain/entities/rating_entity.dart';
import 'package:hatley/domain/entities/review_entity.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackLoadSuccess extends FeedbackState {
  final RatingEntity? rating;
  final ReviewEntity? review;

  const FeedbackLoadSuccess({this.rating, this.review});

  @override
  List<Object?> get props => [rating, review];
}

class FeedbackAddSuccess extends FeedbackState {}

class FeedbackUpdateSuccess extends FeedbackState {}

class FeedbackFailure extends FeedbackState {
  final String message;

  const FeedbackFailure(this.message);

  @override
  List<Object?> get props => [message];
}
