import 'package:creca_test/repository/remote/api/account_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/credit_card.dart';

final accountRepositoryProvider = Provider((ref) => AccountRepository(ref));

class AccountRepository {
  AccountRepository(this.ref);

  final Ref ref;

  List<Account> findAccounts() {
    return const [
      Account(id: '1000ab01', name: 'クレカ未登録太郎'),
      Account(id: '1000ab02', name: 'クレカ登録二郎'),
      Account(id: '1000ab03', name: 'テスト三郎'),
    ];
  }

  Future<CreditCard?> findCreditCard() async {
    final account = ref.read(accountProvider);
    final response = await ref.read(accountApiProvider).inquiry(account);

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
}
