abstract class OfferState{}

class OfferLoading extends OfferState{}

class OfferInitial extends OfferState{

}

class OfferFailure extends OfferState{
  final String errorMessage;
  OfferFailure(this.errorMessage);
}
class OfferSuccess extends OfferState{}