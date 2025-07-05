import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/review_entity.dart';
import 'package:hatley/domain/usecases/review_usecase.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewUsecase reviewUsecase;

  ReviewCubit(this.reviewUsecase) : super(ReviewInitial());

  Future<void> addReview(int orderId, String review) async {
    emit(ReviewLoading());
    final Either<Failure, void> result = await reviewUsecase.addReview(
      orderId,
      review,
    );
    result.fold(
      (failure) => emit(ReviewFailure(_mapFailureToMessage(failure))),
      (_) => emit(ReviewAddSuccess()),
    );
  }

  Future<void> getReviewById(int orderId) async {
    emit(ReviewLoading());
    final Either<Failure, ReviewEntity> result = await reviewUsecase
        .getReviewById(orderId);
    result.fold(
      (failure) => emit(ReviewFailure(_mapFailureToMessage(failure))),
      (review) => emit(ReviewLoadSuccess(review)),
    );
  }

  Future<void> updateReview(int orderId, String review) async {
    emit(ReviewLoading());
    final Either<Failure, void> result = await reviewUsecase.updateReview(
      orderId,
      review,
    );
    result.fold(
      (failure) => emit(ReviewFailure(_mapFailureToMessage(failure))),
      (_) => emit(ReviewUpdateSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
