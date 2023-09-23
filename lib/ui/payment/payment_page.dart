import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/ui/payment/credit_card_input_dialog.dart';
import 'package:creca_test/ui/payment/payment_complete_page.dart';
import 'package:creca_test/ui/payment/payment_controller.dart';
import 'package:creca_test/ui/widgets/app_dialog.dart';

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
        title: const Text('クレカ情報入力'),
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

class _ViewBody extends ConsumerWidget {
  const _ViewBody(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRegistered = ref.watch(paymentIsRegisteredCreditCardProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ViewPaymentInfo(amount),
          const Divider(),
          const _ViewCreditCard(),
          if (isRegistered) const Text('クレジットカード登録済', style: TextStyle(color: Colors.blue)),
          if (!isRegistered) const _ViewCreditCardInput(),
          if (!isRegistered) const Divider(),
          if (!isRegistered) const _InputCardInfoSaveSwitch(),
          if (isRegistered) const _DeleteButton(),
          if (isRegistered) const Spacer(),
          _PaymentButton(amount),
        ],
      ),
    );
  }
}

class _ViewPaymentInfo extends ConsumerWidget {
  const _ViewPaymentInfo(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tranId = ref.watch(paymentTransactionIdProvider);
    return Column(
      children: [
        const Text('[支払い金額]'),
        Text('$amount 円', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('処理ID: $tranId'),
      ],
    );
  }
}

class _ViewCreditCard extends ConsumerWidget {
  const _ViewCreditCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfo = ref.watch(paymentInputCreditCardProvider);
    return CreditCardWidget(
      cardNumber: cardInfo.getShowCardNumeberForWidget(),
      expiryDate: cardInfo.expiryDate,
      cardHolderName: cardInfo.cardHolderName,
      cvvCode: cardInfo.getCvvCode(),
      showBackView: false,
      isHolderNameVisible: true,
      obscureInitialCardNumber: true,
      labelValidThru: '有効\n期限',
      labelCardHolder: 'NAME',
      onCreditCardWidgetChange: (creditCardBrand) {},
    );
  }
}

class _ViewCreditCardInput extends ConsumerWidget {
  const _ViewCreditCardInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleCardList = ref.watch(defaultCardInfoListProvider);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _InputCreditCardButton(),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text('サンプルクレカ情報から選ぶ'),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(width: 1, color: Colors.grey),
              ),
              expandedAlignment: Alignment.centerLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: sampleCardList.map((e) => _RowSampleCard(name: e.$1, creditCard: e.$2)).toList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputCreditCardButton extends ConsumerWidget {
  const _InputCreditCardButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _showCreditCardInputDialog(context, ref),
      child: const Text('クレカ情報を手入力する'),
    );
  }

  void _showCreditCardInputDialog(BuildContext context, WidgetRef ref) {
    CreditCardInputDialog(
      creditCard: ref.read(paymentInputCreditCardProvider),
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
        const Text('このクレカ情報を登録する'),
        Switch(
          value: ref.watch(paymentIsSaveCreditCardProvider),
          onChanged: (value) {
            ref.read(paymentControllerProvider.notifier).isSaveInputCard(value);
          },
        )
      ],
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _showConfirmDialog(context, ref),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('登録カード情報を削除する'),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, WidgetRef ref) {
    AppDialog.okAndCancel(
      message: '登録されているカード情報を削除します。よろしいですか？',
      onOk: () {
        ref.read(paymentControllerProvider.notifier).deleteCard().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('カード情報を削除しました'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      },
    );
  }
}

class _PaymentButton extends ConsumerWidget {
  const _PaymentButton(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enable = ref.watch(paymentEnableButtonProvider);

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
      onOk: () {
        final payment = Payment.create(
          creditCard: ref.read(paymentInputCreditCardProvider),
          transactionId: ref.read(paymentTransactionIdProvider),
          amount: amount,
          isSaveCardInfo: ref.read(paymentIsSaveCreditCardProvider),
        );
        PaymentCompletePage.start(context, payment).then((value) => Navigator.pop(context));
      },
    ).show(context);
  }
}
