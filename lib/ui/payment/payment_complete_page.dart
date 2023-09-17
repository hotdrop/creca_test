import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creca_test/model/payment.dart';
import 'package:creca_test/ui/payment/payment_complete_controller.dart';

class PaymentCompletePage extends ConsumerWidget {
  const PaymentCompletePage._(this.payment);

  static Future<void> start(BuildContext context, Payment payment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentCompletePage._(payment)),
    );
  }

  final Payment payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い完了'),
      ),
      body: ref.watch(paymentCompleteControllerProvider(payment)).when(
            data: (data) => _ViewBody(payment, data.$1, data.$2),
            error: (err, st) => _ViewBody(payment, -1, '$err'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.payment, this.resultCode, this.message);

  final Payment payment;
  final int resultCode;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _ViewPaymentInfo(payment),
          const Divider(),
          const SizedBox(height: 16),
          _ViewResultCode(resultCode),
          const SizedBox(height: 16),
          Text(message),
          const Spacer(),
          const _CloseButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ViewPaymentInfo extends ConsumerWidget {
  const _ViewPaymentInfo(this.payment);

  final Payment payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('[支払い金額]'),
        Text('${payment.amount} 円', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('処理ID: ${payment.transactionId}'),
      ],
    );
  }
}

class _ViewResultCode extends StatelessWidget {
  const _ViewResultCode(this.resultCode);

  final int resultCode;

  @override
  Widget build(BuildContext context) {
    final isSuccess = (resultCode < 400 && resultCode >= 200) ? true : false;

    final icons = isSuccess ? Icons.check_circle : Icons.error_rounded;
    final label = isSuccess ? '正常' : 'エラー';
    final color = isSuccess ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icons,
          color: color,
          size: 50,
        ),
        const SizedBox(width: 16),
        Text(label, style: TextStyle(color: color, fontSize: 24)),
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
