import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/ui/payment/credit_card_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creca_test/ui/widgets/app_dialog.dart';
import 'package:creca_test/ui/payment/payment_controller.dart';
import 'package:creca_test/ui/widgets/app_progress_dialog.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage._(this.amount);

  static void start(BuildContext context, int amount) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentPage._(amount)),
    );
  }

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カード情報入力'),
      ),
      body: ref.watch(paymentControllerProvider).when(
            data: (_) => _ViewBody(amount),
            error: (err, _) => _ViewError('$err'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}

class _ViewError extends StatelessWidget {
  const _ViewError(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'エラーが発生しました。内容をご確認ください。\n $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('[支払い金額]'),
              Text('$amount 円', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              const _ViewCreditCard(),
              const Divider(),
              const _ViewCreditCardInput(),
              const _InputCardInfoSaveSwitch(),
              _PaymentButton(amount),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewCreditCard extends ConsumerWidget {
  const _ViewCreditCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfo = ref.watch(inputCreditCardProvider);
    final isRegisteredCard = ref.watch(isRegisteredCardProvider);

    return Column(
      children: [
        CreditCardWidget(
          cardNumber: cardInfo.cardNumber,
          expiryDate: cardInfo.expiryDate,
          cardHolderName: cardInfo.cardHolderName,
          cvvCode: cardInfo.cvvCode,
          showBackView: false,
          isHolderNameVisible: true,
          labelValidThru: '有効\n期限',
          labelCardHolder: 'NAME',
          onCreditCardWidgetChange: (creditCardBrand) {},
        ),
        if (isRegisteredCard) const Text('カード情報登録済', style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class _ViewCreditCardInput extends ConsumerWidget {
  const _ViewCreditCardInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleCardList = ref.watch(defaultCardInfoListProvider);
    return Column(
      children: [
        const SizedBox(height: 8),
        const _InputCreditCardButton(),
        const SizedBox(height: 8),
        const Text('サンプルカードから選ぶ'),
        ...sampleCardList.map((e) => _RowSampleCard(name: e.$1, creditCard: e.$2)).toList(),
      ],
    );
  }
}

class _InputCreditCardButton extends ConsumerWidget {
  const _InputCreditCardButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _showCreditCardInputDialog(context, ref),
      child: const Text('カード情報を手入力する'),
    );
  }

  void _showCreditCardInputDialog(BuildContext context, WidgetRef ref) {
    CreditCardInputDialog(
      creditCard: ref.read(inputCreditCardProvider),
      onChange: (CreditCardModel? inputCardInfo) {
        ref.read(paymentControllerProvider.notifier).input(inputCardInfo);
      },
    ).show(context);
  }
}

class _RowSampleCard extends ConsumerWidget {
  const _RowSampleCard({required this.name, required this.creditCard});

  final String name;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.credit_card),
        title: Text(name),
        subtitle: Text(creditCard.cardHolderName),
        onTap: () => ref.read(paymentControllerProvider.notifier).setSampleCard(creditCard),
      ),
    );
  }
}

class _InputCardInfoSaveSwitch extends ConsumerWidget {
  const _InputCardInfoSaveSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('このカード情報を登録する'),
        Switch(
          value: ref.watch(isSaveCreditCardProvider),
          onChanged: (value) {
            ref.read(paymentControllerProvider.notifier).isSaveInputCard(value);
          },
        )
      ],
    );
  }
}

class _PaymentButton extends ConsumerWidget {
  const _PaymentButton(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enable = ref.watch(enablePaymentButtonProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: enable ? () => _showConfirmDialog(context, ref) : null,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('支払いを実行する'),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, WidgetRef ref) {
    AppDialog.okAndCancel(
      message: 'テスト支払いします。よろしいですか？',
      onOk: () async => await _payment(context, ref),
    ).show(context);
  }

  Future<void> _payment(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog();
    progressDialog.show(
      context,
      execute: () => ref.read(paymentControllerProvider.notifier).payment(amount),
      onSuccess: (_) => AppDialog.ok(message: 'テスト実行が完了しました。', onOk: () => Navigator.pop(context)).show(context),
      onError: (err, st) => AppDialog.ok(message: '$err').show(context),
    );
  }
}
