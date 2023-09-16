import 'package:creca_test/model/account.dart';
import 'package:creca_test/repository/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  void build() {}

  List<Account> findAccounts() {
    return ref.read(accountRepositoryProvider).findAll();
  }

  void changeAccount(Account account) {
    ref.read(accountProvider.notifier).changeAccunt(account);
  }
}

final isSelectAccountProvider = Provider.family<bool, Account>((ref, account) {
  return account.id == ref.watch(accountProvider).id;
});

final homeAmountsProvider = Provider<List<int>>((_) => [1000, 5000, 10000]);
