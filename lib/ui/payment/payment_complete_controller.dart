import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/repository/payment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_complete_controller.g.dart';

@riverpod
class PaymentCompleteController extends _$PaymentCompleteController {
  @override
  Future<(int, String)> build(CreditCard creditCard, int amount, bool isSave) async {
    //  前回登録していない→今回登録する=カード情報を登録する
    //  前回登録している→今回登録しない=カード情報を消す
    return await ref.read(paymentRepositoryProvider).payment(
          creditCard: creditCard,
          amount: amount,
          isSave: isSave,
        );
  }
}
