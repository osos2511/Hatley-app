import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/rating_entity.dart';
import 'package:hatley/domain/entities/review_entity.dart';
import 'package:hatley/domain/usecases/rating_usecase.dart';
import 'package:hatley/domain/usecases/review_usecase.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final RatingUsecase ratingUsecase;
  final ReviewUsecase reviewUsecase;

  FeedbackCubit({
    required this.ratingUsecase,
    required this.reviewUsecase,
  }) : super(FeedbackInitial());

  Future<void> loadFeedback(int orderId) async {
    emit(FeedbackLoading());

    final ratingResult = await ratingUsecase.getRatingById(orderId);
    final reviewResult = await reviewUsecase.getReviewById(orderId);

    RatingEntity? rating;
    ReviewEntity? review;

    // نجيب تقييم اذا نجح
    ratingResult.fold(
          (_) => rating = null,
          (r) => rating = r,
    );

    // نجيب مراجعة اذا نجح
    reviewResult.fold(
          (_) => review = null,
          (rev) => review = rev,
    );

    emit(FeedbackLoadSuccess(rating: rating, review: review));
  }

  Future<void> addOrUpdateRating(int orderId, int ratingValue) async {
    emit(FeedbackLoading());

    // نجرب لو في تقييم سابق نحدثه، وإلا نضيف جديد
    final getResult = await ratingUsecase.getRatingById(orderId);
    await getResult.fold(
          (failure) async {
        // لا يوجد تقييم، نضيف جديد
        final addResult = await ratingUsecase.addRating(orderId, ratingValue);
        addResult.fold(
              (f) => emit(FeedbackFailure(_mapFailureToMessage(f))),
              (_) => emit(FeedbackAddSuccess()),
        );
      },
          (existingRating) async {
        // يوجد تقييم سابق، نحدثه
        final updateResult =
        await ratingUsecase.updateRating(orderId, ratingValue);
        updateResult.fold(
              (f) => emit(FeedbackFailure(_mapFailureToMessage(f))),
              (_) => emit(FeedbackUpdateSuccess()),
        );
      },
    );
  }

  Future<void> addOrUpdateReview(int orderId, String reviewText) async {
    emit(FeedbackLoading());

    final getResult = await reviewUsecase.getReviewById(orderId);
    await getResult.fold(
          (failure) async {
        // لا يوجد مراجعة، نضيف جديد
        final addResult = await reviewUsecase.addReview(orderId, reviewText);
        addResult.fold(
              (f) => emit(FeedbackFailure(_mapFailureToMessage(f))),
              (_) => emit(FeedbackAddSuccess()),
        );
      },
          (existingReview) async {
        // يوجد مراجعة سابقة، نحدثها
        final updateResult =
        await reviewUsecase.updateReview(orderId, reviewText);
        updateResult.fold(
              (f) => emit(FeedbackFailure(_mapFailureToMessage(f))),
              (_) => emit(FeedbackUpdateSuccess()),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
