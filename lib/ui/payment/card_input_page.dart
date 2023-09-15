import 'package:creca_test/model/item.dart';
import 'package:creca_test/ui/widgets/app_dialog.dart';
import 'package:creca_test/ui/payment/credit_controller.dart';
import 'package:creca_test/ui/widgets/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardInputPage extends ConsumerWidget {
  const CardInputPage._(this.item);

  static void start(BuildContext context, Item selectItem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CardInputPage._(selectItem)),
    );
  }

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カード情報入力'),
      ),
      body: ref.watch(creditControllerProvider).when(
            data: (_) => _ViewBody(item),
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
  const _ViewBody(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ViewItem(item),
          const _ViewCreditCard(),
          const _ViewRegisterCreditCardLabel(),
          const SizedBox(height: 8),
          const _ViewCreditCardInput(),
          _ViewButton(item),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  const _ViewItem(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Image.asset(item.imagePath, width: 50, height: 50),
        ),
        title: Text(item.name),
        subtitle: Text('${item.price} 円'),
      ),
    );
  }
}

class _ViewCreditCard extends ConsumerWidget {
  const _ViewCreditCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfo = ref.watch(inputCreditCardProvider);

    return CreditCardWidget(
      cardNumber: cardInfo.cardNumber,
      expiryDate: cardInfo.expiryDate,
      cardHolderName: cardInfo.cardHolderName,
      cvvCode: cardInfo.cvvCode,
      showBackView: false,
      isHolderNameVisible: true,
      labelValidThru: '有効\n期限',
      labelCardHolder: 'NAME',
      onCreditCardWidgetChange: (creditCardBrand) {},
    );
  }
}

class _ViewRegisterCreditCardLabel extends ConsumerWidget {
  const _ViewRegisterCreditCardLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRegisteredCard = ref.watch(isRegisteredCardProvider);
    if (isRegisteredCard) {
      return const Text('このカード情報は登録されています', style: TextStyle(color: Colors.blue));
    } else {
      return const SizedBox();
    }
  }
}

class _ViewCreditCardInput extends ConsumerWidget {
  const _ViewCreditCardInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleArea = ref.watch(visibleInputAreaProvider);
    final rowLabel = visibleArea ? 'カード情報入力領域を非表示にする' : 'カード情報入力エリアを表示する';

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                ref.read(creditControllerProvider.notifier).changeVisibleInputArea();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rowLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Icon(visibleArea ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down),
                ],
              ),
            ),
            if (visibleArea)
              const Column(
                children: [
                  _ViewCreditCardForm(),
                  _ViewCardRegisterSwitch(),
                  SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ViewCreditCardForm extends ConsumerWidget {
  const _ViewCreditCardForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardInfo = ref.watch(inputCreditCardProvider);

    return CreditCardForm(
      formKey: ref.watch(creditCardInputValidateKey),
      cardNumber: cardInfo.cardNumber,
      expiryDate: cardInfo.expiryDate,
      cardHolderName: cardInfo.cardHolderName,
      cvvCode: cardInfo.cvvCode,
      onCreditCardModelChange: (CreditCardModel? inputCardInfo) {
        if (inputCardInfo == null) {
          return;
        }
        ref.read(creditControllerProvider.notifier).input(inputCardInfo);
      },
      themeColor: Colors.lightBlue,
      cardNumberDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'カード番号',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '有効期限',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'セキュリティコード',
        hintText: 'XXX',
      ),
      cardHolderDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name',
      ),
    );
  }
}

class _ViewCardRegisterSwitch extends ConsumerWidget {
  const _ViewCardRegisterSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('カード情報を保存する'),
        const SizedBox(width: 16),
        Switch(
          value: ref.watch(isSaveCreditCardProvider),
          onChanged: (value) {
            ref.read(creditControllerProvider.notifier).isSaveInputCard(value);
          },
        )
      ],
    );
  }
}

class _ViewButton extends ConsumerWidget {
  const _ViewButton(this.item);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enable = ref.watch(enablePaymentButtonProvider);

    return ElevatedButton(
      onPressed: enable
          ? () {
              AppDialog.okAndCancel(
                message: 'テスト支払いします。よろしいですか？',
                onOk: () async => await _payment(context, ref),
              ).show(context);
            }
          : null,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('この内容で支払いする'),
      ),
    );
  }

  Future<void> _payment(BuildContext context, WidgetRef ref) async {
    const progressDialog = AppProgressDialog();
    progressDialog.show(
      context,
      execute: () => ref.read(creditControllerProvider.notifier).payment(item),
      onSuccess: (_) => AppDialog.ok(message: 'テスト実行が完了しました。', onOk: () => Navigator.pop(context)).show(context),
      onError: (err, st) => AppDialog.ok(message: '$err').show(context),
    );
  }
}
