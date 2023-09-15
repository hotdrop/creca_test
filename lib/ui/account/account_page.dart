import 'package:creca_test/model/account.dart';
import 'package:creca_test/ui/account/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: const Column(
        children: [
          _ViewAccounts(),
        ],
      ),
    );
  }
}

class _ViewAccounts extends ConsumerWidget {
  const _ViewAccounts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: ref
            .watch(accountControllerProvider.notifier) //
            .findAll()
            .map((e) => _RowAccount(e))
            .toList(),
      ),
    );
  }
}

class _RowAccount extends ConsumerWidget {
  const _RowAccount(this.account);

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(isSelectAccountProvider(account));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          ref.read(accountControllerProvider.notifier).changeAccount(account);
        },
        child: ListTile(
          leading: const Icon(Icons.account_circle, size: 32),
          title: Text(account.name),
          subtitle: Text(account.id, style: const TextStyle(color: Colors.grey)),
          trailing: isSelected ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
        ),
      ),
    );
  }
}
