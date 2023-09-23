import 'package:creca_test/repository/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final accountProvider = NotifierProvider<AccountNotifier, Account>(AccountNotifier.new);

class AccountNotifier extends Notifier<Account> {
  @override
  Account build() {
    return ref.read(accountRepositoryProvider).findAccounts().first;
  }

  void changeAccunt(Account selectAccount) {
    state = selectAccount;
  }
}

class Account {
  const Account({required this.id, required this.name});
  final String id;
  final String name;
}
