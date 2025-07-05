import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/rating_entity.dart';
import 'package:hatley/domain/usecases/rating_usecase.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingUsecase ratingUsecase;

  RatingCubit(this.ratingUsecase) : super(RatingInitial());

  Future<void> addRating(int orderId, int rating) async {
    emit(RatingLoading());
    final Either<Failure, void> result = await ratingUsecase.addRating(
      orderId,
      rating,
    );
    result.fold(
      (failure) => emit(RatingFailure(_mapFailureToMessage(failure))),
      (_) => emit(RatingAddSuccess()),
    );
  }

  Future<void> getRatingById(int orderId) async {
    emit(RatingLoading());
    final Either<Failure, RatingEntity> result = await ratingUsecase
        .getRatingById(orderId);
    result.fold(
      (failure) => emit(RatingFailure(_mapFailureToMessage(failure))),
      (rating) => emit(RatingLoadSuccess(rating)),
    );
  }

  Future<void> updateRating(int orderId, int rating) async {
    emit(RatingLoading());
    final Either<Failure, void> result = await ratingUsecase.updateRating(
      orderId,
      rating,
    );
    result.fold(
      (failure) => emit(RatingFailure(_mapFailureToMessage(failure))),
      (_) => emit(RatingUpdateSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
