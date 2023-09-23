import 'dart:convert';

import 'package:creca_test/common/env.dart';
import 'package:creca_test/repository/remote/entity/app_request.dart';

class InquiryRequest extends AppRequest {
  const InquiryRequest({
    required this.accountId,
    required super.idempotencyId,
  }) : super(host: Env.hostStgApi, endpoint: Env.endpointInquiry);

  final String accountId;

  @override
  String body() {
    return json.encode({'accountId': accountId});
  }
}
