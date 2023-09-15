import 'package:creca_test/model/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final accountRepositoryProvider = Provider((_) => AccountRepository());

class AccountRepository {
  AccountRepository();

  List<Account> findAll() {
    return const [
      Account(id: '1000ab01', name: 'クレカ未登録太郎'),
      Account(id: '1000ab02', name: 'クレカ登録二郎'),
      Account(id: '1000ab03', name: 'テスト三郎'),
    ];
  }
}
