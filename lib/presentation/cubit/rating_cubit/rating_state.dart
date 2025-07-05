import 'package:equatable/equatable.dart';
import 'package:hatley/domain/entities/rating_entity.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingAddSuccess extends RatingState {}

class RatingUpdateSuccess extends RatingState {}

class RatingLoadSuccess extends RatingState {
  final RatingEntity rating;

  const RatingLoadSuccess(this.rating);

  @override
  List<Object?> get props => [rating];
}

class RatingFailure extends RatingState {
  final String message;

  const RatingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
