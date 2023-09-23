import 'dart:convert';

import 'package:creca_test/common/env.dart';
import 'package:creca_test/repository/remote/entity/app_request.dart';

class DeleteCardRequest extends AppRequest {
  const DeleteCardRequest({
    required this.accountId,
    required this.cardId,
    required super.idempotencyId,
  }) : super(host: Env.hostStgApi, endpoint: Env.endpointPayment);

  final String accountId;
  final String cardId;

  @override
  String body() {
    return json.encode({
      'accountId': accountId,
      'cardId': cardId,
    });
  }
}
