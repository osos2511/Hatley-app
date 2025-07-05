import 'package:equatable/equatable.dart';
import 'package:hatley/domain/entities/review_entity.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewAddSuccess extends ReviewState {}

class ReviewUpdateSuccess extends ReviewState {}

class ReviewLoadSuccess extends ReviewState {
  final ReviewEntity review;

  const ReviewLoadSuccess(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewFailure extends ReviewState {
  final String message;

  const ReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}
