// offer_state.dart (Updated suggestion)

abstract class OfferState {}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferFailure extends OfferState {
  final String errorMessage;
  OfferFailure(this.errorMessage);
}

// هذه الحالة لنجاح الرفض مثلاً، أو نجاحات أخرى لا تتطلب معرفة الـ orderId
class OfferDeclinedSuccess extends OfferState { // تم تغيير الاسم لتوضيح الغرض
  final String message; // رسالة توضيحية لعملية الرفض
  OfferDeclinedSuccess(this.message);
}

// هذه هي الحالة المحددة لنجاح القبول
class OfferAcceptedSuccess extends OfferState {
  final int orderId; // قم بتمرير الـ orderId هنا ليكون متاحاً عند التحويل
  OfferAcceptedSuccess({required this.orderId});
}