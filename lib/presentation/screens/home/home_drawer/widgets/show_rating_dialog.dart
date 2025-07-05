import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hatley/presentation/cubit/rating_cubit/rating_cubit.dart';
import 'package:hatley/presentation/cubit/rating_cubit/rating_state.dart';
import 'package:hatley/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:hatley/presentation/cubit/review_cubit/review_state.dart';

class RatingReviewDialog extends StatefulWidget {
  final int orderId;

  const RatingReviewDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  State<RatingReviewDialog> createState() => _RatingReviewDialogState();
}

class _RatingReviewDialogState extends State<RatingReviewDialog> {
  late final TextEditingController _reviewController;
  double _ratingValue = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();

    final ratingCubit = context.read<RatingCubit>();
    final reviewCubit = context.read<ReviewCubit>();

    ratingCubit.getRatingById(widget.orderId).then((_) {
      final ratingState = ratingCubit.state;
      if (ratingState is RatingLoadSuccess) {
        setState(() {
          _ratingValue = ratingState.rating.rating.toDouble();
        });
      }
    });

    reviewCubit.getReviewById(widget.orderId).then((_) {
      final reviewState = reviewCubit.state;
      if (reviewState is ReviewLoadSuccess) {
        setState(() {
          _reviewController.text = reviewState.review.review;
        });
      }
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool get _isInputValid =>
      _ratingValue >= 1 &&
      _reviewController.text.trim().isNotEmpty &&
      !_isSubmitting;

  Future<void> _submit() async {
    final ratingCubit = context.read<RatingCubit>();
    final reviewCubit = context.read<ReviewCubit>();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentRatingState = ratingCubit.state;
      final currentReviewState = reviewCubit.state;

      final isSameRating =
          currentRatingState is RatingLoadSuccess &&
          currentRatingState.rating.rating.toDouble() == _ratingValue;
      final isSameReview =
          currentReviewState is ReviewLoadSuccess &&
          currentReviewState.review.review.trim() ==
              _reviewController.text.trim();

      if (isSameRating && isSameReview) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No changes to update')));
        setState(() => _isSubmitting = false);
        return;
      }

      if (currentRatingState is RatingLoadSuccess) {
        await ratingCubit.updateRating(widget.orderId, _ratingValue.toInt());
      } else {
        await ratingCubit.addRating(widget.orderId, _ratingValue.toInt());
      }

      if (currentReviewState is ReviewLoadSuccess) {
        await reviewCubit.updateReview(
          widget.orderId,
          _reviewController.text.trim(),
        );
      } else {
        await reviewCubit.addReview(
          widget.orderId,
          _reviewController.text.trim(),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review & Rating submitted')),
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingCubit, RatingState>(
      listener: (context, state) {
        if (state is RatingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load rating: ${state.message}')),
          );
        }
      },
      child: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load review: ${state.message}'),
              ),
            );
          }
        },
        child: AlertDialog(
          title: const Text(
            'Rate & Review',
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: _ratingValue,
                  minRating: 1,
                  maxRating: 5,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemBuilder:
                      (context, _) =>
                          const Icon(Icons.star, color: Colors.blue),
                  onRatingUpdate: (rating) {
                    setState(() => _ratingValue = rating);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!_isSubmitting) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _isInputValid ? _submit : null,
              child:
                  _isSubmitting
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text('Add Review'),
            ),
          ],
        ),
      ),
    );
  }
}
