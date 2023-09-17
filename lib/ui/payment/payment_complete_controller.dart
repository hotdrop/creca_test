import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/repository/payment_repository.dart';

part 'payment_complete_controller.g.dart';

@riverpod
class PaymentCompleteController extends _$PaymentCompleteController {
  @override
  Future<(int, String)> build(Payment payment) async {
    return await ref.read(paymentRepositoryProvider).payment(payment);
  }
}
