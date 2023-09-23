import 'package:creca_test/model/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardInputDialog {
  const CreditCardInputDialog({required this.creditCard, required this.onChange});

  final CreditCard creditCard;
  final Function(CreditCardModel?) onChange;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return _CustomAlertDialog(
          creditCard: creditCard,
          onChange: onChange,
        );
      },
    );
  }
}

class _CustomAlertDialog extends StatefulWidget {
  const _CustomAlertDialog({required this.creditCard, required this.onChange});

  final CreditCard creditCard;
  final Function(CreditCardModel?) onChange;

  @override
  State<_CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<_CustomAlertDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CreditCardForm(
              formKey: formKey,
              cardNumber: widget.creditCard.cardNumber,
              expiryDate: widget.creditCard.expiryDate,
              cardHolderName: widget.creditCard.cardHolderName,
              cvvCode: widget.creditCard.getCvvCode(),
              onCreditCardModelChange: widget.onChange,
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
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
