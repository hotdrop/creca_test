import 'package:creca_test/model/app_exception.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/model/unique_id_generator.dart';
import 'package:creca_test/repository/remote/entity/payment_request.dart';
import 'package:creca_test/repository/remote/entity/payment_response.dart';
import 'package:creca_test/repository/remote/http_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentApiProvider = Provider((ref) => PaymentApi(ref));

class PaymentApi {
  const PaymentApi(this.ref);
  final Ref ref;

  Future<PaymentResponse> payment(Payment payment) async {
    final request = PaymentRequest(
      transactionId: payment.transactionId,
      creditCard: payment.creditCard,
      amount: payment.amount,
      idempotencyId: ref.read(uniqueIdGeneratorProvider).generate(),
    );
    final response = await ref.read(httpClientProvider).post(request);
    return response.when(
      success: (data) => PaymentResponse.fromJson(data.mapItem),
      error: (error) => throw AppException(code: error.statusCode, overview: error.overview, detail: error.detail),
    );
  }
}
