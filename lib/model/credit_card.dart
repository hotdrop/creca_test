class CreditCard {
  const CreditCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });

  factory CreditCard.init() {
    return const CreditCard(cardNumber: '', expiryDate: '', cardHolderName: '', cvvCode: '');
  }

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
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

  CreditCard copyWith({
    bool? isRegistered,
    bool? isRemoveRegisterCardInfo,
  }) {
    return CreditCard(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
    );
  }
}
