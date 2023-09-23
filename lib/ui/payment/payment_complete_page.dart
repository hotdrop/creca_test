import 'package:creca_test/model/app_exception.dart';
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
            data: (data) => _ViewBody(payment, responseBody: data),
            error: (err, st) {
              final appException = err as AppException;
              return _ViewBody(payment, appException: appException);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.payment, {this.responseBody, this.appException});

  final Payment payment;
  final String? responseBody;
  final AppException? appException;

  @override
  Widget build(BuildContext context) {
    final resultCode = (appException == null) ? 200 : appException!.code;
    final resultBody = (appException == null) ? responseBody! : appException.toString();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _ViewPaymentInfo(payment),
          const Divider(),
          const SizedBox(height: 16),
          _ViewResult(resultCode, resultBody),
          const SizedBox(height: 16),
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

class _ViewResult extends StatelessWidget {
  const _ViewResult(this.resultCode, this.body);

  final int resultCode;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isSuccess = (resultCode < 400 && resultCode >= 200) ? true : false;

    final icons = isSuccess ? Icons.check_circle : Icons.error_rounded;
    final color = isSuccess ? Colors.green : Colors.red;

    return Flexible(
      child: Column(
        children: [
          Icon(icons, color: color, size: 50),
          const SizedBox(height: 8),
          Text('HTTP Status Code: $resultCode', style: TextStyle(color: color, fontSize: 20)),
          const SizedBox(height: 16),
          Flexible(
              child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: SingleChildScrollView(
                child: Text(body),
              ),
            ),
          )),
        ],
      ),
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
