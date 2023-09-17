import 'package:creca_test/common/logger.dart';
import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository(ref));

class PaymentRepository {
  PaymentRepository(this.ref);

  final Ref ref;

  Future<CreditCard?> findCreditCardInfo() async {
    // TODO カード情報が登録されているか取得する
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final account = ref.read(accountProvider);
    if (account.id == '1000ab02') {
      return const CreditCard(
        cardNumber: '1111 2222 3333 4444',
        expiryDate: '12/25',
        cardHolderName: 'TEST TAROU',
        cvvCode: '123',
        isRegistered: true,
      );
    }
    return null;
  }

  Future<(int, String)> payment({required CreditCard creditCard, required int amount, required bool isSave}) async {
    // TODO カード決済する
    await Future<void>.delayed(const Duration(seconds: 1));

    final isRegister = !creditCard.isRegistered && isSave;
    final isRemove = creditCard.isRegistered && !isSave;

    if (isRegister) {
      AppLogger.d('カード情報を登録します。');
    } else if (isRemove) {
      AppLogger.d('カード情報を削除します。');
    }

    return (200, '成功しました');
  }
}
