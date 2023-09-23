import 'dart:convert';

import 'package:creca_test/common/env.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/repository/remote/entity/app_request.dart';

class PaymentRequest extends AppRequest {
  const PaymentRequest({
    required this.transactionId,
    required this.creditCard,
    required this.amount,
    required super.idempotencyId,
  }) : super(host: Env.hostStgApi, endpoint: Env.endpointInquiry);

  final String transactionId;
  final CreditCard creditCard;
  final int amount;

  @override
  String body() {
    Map<String, dynamic> jsonMap = {
      'transacitonId': transactionId,
      'amount': amount,
    };

    final cardInfo = creditCard;
    switch (cardInfo) {
      case CreditCardNewInput():
        // 本当はカード情報を直接設定するのはあり得ない。トークンなど別の形式にして送る
        jsonMap['cardInfo'] = {
          'cardNumber': cardInfo.cardNumber,
          'cardExpiryDate': cardInfo.expiryDate,
          'cardHolderName': cardInfo.cardHolderName,
          'cvv': cardInfo.cvvCode,
        };
      case CreditCardRegistered():
        jsonMap['cardRegister'] = {
          'cardId': cardInfo.cardId,
        };
    }

    return json.encode(jsonMap);
  }
}
