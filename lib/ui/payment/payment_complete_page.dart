import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/ui/payment/payment_complete_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentCompletePage extends ConsumerWidget {
  const PaymentCompletePage._(this.creditCard, this.amount, this.isSave);

  static Future<void> start(BuildContext context, {required CreditCard creditCard, required int amount, required bool isSave}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentCompletePage._(creditCard, amount, isSave)),
    );
  }

  final CreditCard creditCard;
  final int amount;
  final bool isSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い完了'),
      ),
      body: ref.watch(paymentCompleteControllerProvider(creditCard, amount, isSave)).when(
            data: (data) => _ViewBody(data.$1, data.$2),
            error: (err, st) => _ViewBody(-1, '$err'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.resultCode, this.message);

  final int resultCode;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _ViewResultCode(resultCode),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          const _CloseButton(),
        ],
      ),
    );
  }
}

class _ViewResultCode extends StatelessWidget {
  const _ViewResultCode(this.resultCode);

  final int resultCode;

  @override
  Widget build(BuildContext context) {
    final isSuccess = resultCode < 400 ? true : false;

    final icons = isSuccess ? Icons.check_circle : Icons.error_rounded;
    final label = isSuccess ? '正常' : 'エラー';
    final color = isSuccess ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icons, color: color),
        const SizedBox(width: 16),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('閉じる'),
      ),
    );
  }
}
