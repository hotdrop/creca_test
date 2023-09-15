import 'package:creca_test/model/account.dart';
import 'package:creca_test/repository/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_controller.g.dart';

@riverpod
class AccountController extends _$AccountController {
  @override
  void build() {}

  List<Account> findAll() {
    return ref.read(accountRepositoryProvider).findAll();
  }

  void changeAccount(Account account) {
    ref.read(accountProvider.notifier).changeAccunt(account);
  }
}

final isSelectAccountProvider = Provider.family<bool, Account>((ref, account) {
  return account.id == ref.watch(accountProvider).id;
});
