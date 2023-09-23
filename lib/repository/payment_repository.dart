import 'package:creca_test/model/app_exception.dart';
import 'package:creca_test/model/history.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/repository/local/history_dao.dart';
import 'package:creca_test/repository/remote/api/payment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository(ref));

class PaymentRepository {
  PaymentRepository(this.ref);

  final Ref ref;

  Future<List<History>> findHistories() async {
    return await ref.read(historyDaoProvider).findAll();
  }

  Future<String> payment(Payment payment) async {
    try {
      final response = await ref.read(paymentApiProvider).payment(payment);
      await ref.read(historyDaoProvider).save(payment, 200, '支払い成功');
      return response.toString();
    } on AppException catch (e) {
      await ref.read(historyDaoProvider).save(payment, e.code, '${e.overview} [detail]:${e.detail}');
      rethrow;
    }
  }
}
