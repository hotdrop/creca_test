import 'package:creca_test/common/logger.dart';
import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/model/history.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/model/unique_id_generator.dart';
import 'package:creca_test/repository/local/history_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository(ref));

class PaymentRepository {
  PaymentRepository(this.ref);

  final Ref ref;

  Future<CreditCard?> findCreditCard() async {
    // TODO カード情報が登録されているか取得する
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final account = ref.read(accountProvider);
    if (account.id == '1000ab02') {
      return const CreditCard(
        cardNumber: '1111 2222 3333 4444',
        expiryDate: '12/25',
        cardHolderName: 'TEST TAROU',
        cvvCode: '123',
      );
    }
    return null;
  }

  String generateTransactionId() {
    return ref.read(uniqueIdGeneratorProvider).generate();
  }

  Future<List<History>> findHistories() async {
    return await ref.read(historyDaoProvider).findAll();
  }

  Future<(int, String)> payment(Payment payment) async {
    // TODO カード決済のAPIを実行する
    await Future<void>.delayed(const Duration(seconds: 1));

    //  前回登録していない→今回登録する=カード情報を登録する
    //  前回登録している→今回登録しない=カード情報を消す
    if (payment.isRegisterCardInfo()) {
      AppLogger.d('カード情報を登録します。');
    } else if (payment.isRemoveCardInfo()) {
      AppLogger.d('カード情報を削除します。');
    }

    final account = ref.read(accountProvider);
    if (account.id == '1000ab03') {
      const message = 'Internal Server Error. AE001 このカード情報はXXのため利用できません。';
      await ref.read(historyDaoProvider).save(payment, 500, message);
      return (500, message);
    } else {
      const message = '成功しました';
      await ref.read(historyDaoProvider).save(payment, 200, message);
      return (200, message);
    }
  }
}
