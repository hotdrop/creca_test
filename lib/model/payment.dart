import 'package:creca_test/model/credit_card.dart';

class Payment {
  Payment._(
    this.creditCard,
    this.transactionId,
    this.amount,
    this.isSaveCardInfo,
  );

  factory Payment.create({
    required CreditCard creditCard,
    required String transactionId,
    required int amount,
    required bool isSaveCardInfo,
  }) {
    return Payment._(creditCard, transactionId, amount, isSaveCardInfo);
  }

  final CreditCard creditCard;
  final String transactionId;
  final int amount;
  final bool isSaveCardInfo;

  String? getCardId() {
    final card = creditCard;
    switch (card) {
      case CreditCardNewInput():
        return null;
      case CreditCardRegistered():
        return card.cardId;
    }
  }

  ///
  /// 既存のカードを使う場合はtrue
  ///
  bool isUseRegisteredCard() {
    switch (creditCard) {
      case CreditCardNewInput():
        return false;
      case CreditCardRegistered():
        return true;
    }
  }
}
