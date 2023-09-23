sealed class CreditCard {
  const CreditCard(this.cardNumber, this.expiryDate, this.cardHolderName);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;

  String getCvvCode();
  String getShowCardNumeberForWidget();
}

class CreditCardNewInput extends CreditCard {
  const CreditCardNewInput({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required this.cvvCode,
  }) : super(cardNumber, expiryDate, cardHolderName);

  factory CreditCardNewInput.init() {
    return const CreditCardNewInput(cardNumber: '', expiryDate: '', cardHolderName: '', cvvCode: '');
  }

  final String cvvCode;

  String getCardNumberOnlyNum() {
    return cardNumber.replaceAll(' ', '');
  }

  String getExpiryYear() {
    return expiryDate.substring(3, 5);
  }

  String getExpiryMonth() {
    return expiryDate.substring(0, 2);
  }

  bool isEmpty() {
    return cardNumber.isEmpty && expiryDate.isEmpty && cardHolderName.isEmpty && cvvCode.isEmpty;
  }

  @override
  String getCvvCode() => cvvCode;

  @override
  String getShowCardNumeberForWidget() => cardNumber;
}

class CreditCardRegistered extends CreditCard {
  const CreditCardRegistered._(
    String cardNumber,
    String expiryDate,
    String cardHolderName,
    this.cardId,
  ) : super(cardHolderName, expiryDate, cardHolderName);

  factory CreditCardRegistered.create({
    required String cardId,
    required String cardNumberWithMask,
    required String expiryYear,
    required String expiryMonth,
    required String cardHolderName,
  }) {
    // 登録されているカードはカード番号が下4桁以外マスクされている想定
    return CreditCardRegistered._(
      cardNumberWithMask,
      '$expiryMonth/$expiryYear',
      cardHolderName,
      cardId,
    );
  }

  final String cardId;

  ///
  /// 登録されたカードはCvv情報がないのでマスクして返す。
  @override
  String getCvvCode() => '***';

  @override
  String getShowCardNumeberForWidget() {
    return '1111 1111 1111 ${cardNumber.substring(cardNumber.length - 4)}';
  }
}
