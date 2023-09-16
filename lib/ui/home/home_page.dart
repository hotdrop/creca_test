import 'package:creca_test/model/account.dart';
import 'package:creca_test/ui/home/home_controller.dart';
import 'package:creca_test/ui/payment/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text('使用するアカウントを選択してください。'),
            _ViewAccounts(),
            SizedBox(height: 24),
            Text('支払い金額をタップすると、支払い画面に進みます。'),
            SizedBox(height: 8),
            _ViewAmounts(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ViewAccounts extends ConsumerWidget {
  const _ViewAccounts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: ref
          .watch(homeControllerProvider.notifier) //
          .findAccounts()
          .map((e) => _CardAccount(e))
          .toList(),
    );
  }
}

class _CardAccount extends ConsumerWidget {
  const _CardAccount(this.account);

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
          ref.read(homeControllerProvider.notifier).changeAccount(account);
        },
        child: ListTile(
          leading: const Icon(Icons.account_circle, size: 32),
          title: Text(account.name),
          subtitle: Text(account.id, style: const TextStyle(color: Colors.grey)),
          trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.circle_outlined),
        ),
      ),
    );
  }
}

class _ViewAmounts extends ConsumerWidget {
  const _ViewAmounts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      spacing: 16,
      runSpacing: 16,
      children: ref
          .watch(homeAmountsProvider) //
          .map((e) => _CardAmount(e))
          .toList(),
    );
  }
}

class _CardAmount extends StatelessWidget {
  const _CardAmount(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          PaymentPage.start(context, amount);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('$amount 円'),
        ),
      ),
    );
  }
}
