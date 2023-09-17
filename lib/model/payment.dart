import 'package:creca_test/model/credit_card.dart';

class Payment {
  Payment._(this.creditCard, this.transactionId, this.amount, this._registeredCreditCard, this.isSaveCardInfo);

  factory Payment.create({
    required CreditCard creditCard,
    required String transactionId,
    required int amount,
    required bool registeredCreditCard,
    required bool isSaveCardInfo,
  }) {
    return Payment._(creditCard, transactionId, amount, registeredCreditCard, isSaveCardInfo);
  }

  final CreditCard creditCard;
  final String transactionId;
  final int amount;
  final bool isSaveCardInfo;
  final bool _registeredCreditCard;

  ///
  /// カード未登録で入力したカードを登録希望している場合はtrue
  ///
  bool isRegisterCardInfo() {
    return !_registeredCreditCard && isSaveCardInfo;
  }

  ///
  /// カード登録済でカード登録を希望しない場合はtrue
  ///
  bool isRemoveCardInfo() {
    return _registeredCreditCard && !isSaveCardInfo;
  }
}
