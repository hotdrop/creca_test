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
      Account(id: '1000ab01', name: 'クレカ一郎'),
      Account(id: '1000ab02', name: 'クレカ二郎'),
      Account(id: '1000ab03', name: 'テスト三郎'),
    ];
  }

  Future<CreditCard?> findCreditCard() async {
    final account = ref.read(accountProvider);
    final response = await ref.read(accountApiProvider).inquiry(account);

    if (response.id != null) {
      return CreditCardRegistered.create(
        cardId: response.id!,
        cardNumberWithMask: response.cardNumber!,
        expiryYear: response.expiryYear!,
        expiryMonth: response.expiryMonth!,
        cardHolderName: response.cardHolderName!,
      );
    }
    return null;
  }

  Future<void> deleteCreditCard(CreditCardRegistered creditCard) async {
    final account = ref.read(accountProvider);
    await ref.read(accountApiProvider).deleteCard(account, creditCard);
  }
}
