import 'package:creca_test/common/logger.dart';
import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/model/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository(ref));

class PaymentRepository {
  PaymentRepository(this.ref);

  final Ref ref;

  List<Item> findItems() {
    return const [
      Item(name: '商品その1', price: 1000, imagePath: 'assets/images/01_item.png'),
      Item(name: '商品その2', price: 5000, imagePath: 'assets/images/02_item.png'),
      Item(name: '商品その3', price: 8000, imagePath: 'assets/images/03_item.png'),
    ];
  }

  Future<CreditCard?> findCreditCardInfo() async {
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

  Future<void> payment({
    required CreditCard creditCard,
    required int amount,
    required bool isRegister,
    required bool isRemove,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    // TODO カード決済する

    if (isRegister) {
      AppLogger.d('カード情報を登録します。');
    } else if (isRemove) {
      AppLogger.d('カード情報を削除します。');
    }
  }
}
