import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/app_exception.dart';
import 'package:creca_test/model/unique_id_generator.dart';
import 'package:creca_test/repository/remote/entity/inquiry_request.dart';
import 'package:creca_test/repository/remote/entity/inquiry_response.dart';
import 'package:creca_test/repository/remote/http_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountApiProvider = Provider((ref) => AccountApi(ref));

class AccountApi {
  const AccountApi(this.ref);
  final Ref ref;

  Future<InquiryResponse> inquiry(Account account) async {
    final request = InquiryRequest(
      accountId: account.id,
      idempotencyId: ref.read(uniqueIdGeneratorProvider).generate(),
    );
    final response = await ref.read(httpClientProvider).post(request);
    return response.when(
      success: (success) => InquiryResponse.fromJson(success.mapItem),
      error: (error) => throw AppException(code: error.statusCode, overview: error.overview, detail: error.detail),
    );
  }
}
