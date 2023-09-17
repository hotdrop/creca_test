import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/repository/payment_repository.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<void> build() async {
    final registeredCreditCard = await ref.read(paymentRepositoryProvider).findCreditCardInfo();
    ref.read(_uiStateProvider.notifier).state = _UiState.create(registeredCreditCard);
  }

  ///
  /// カード情報入力
  ///
  void input(CreditCardModel? inputCardInfo) {
    if (inputCardInfo == null) {
      return;
    }

    final newCardInfo = CreditCard(
      cardNumber: inputCardInfo.cardNumber,
      expiryDate: inputCardInfo.expiryDate,
      cardHolderName: inputCardInfo.cardHolderName,
      cvvCode: inputCardInfo.cvvCode,
      isRegistered: ref.read(_uiStateProvider).isRegistered(),
    );

    final newUiState = ref.read(_uiStateProvider).copyWith(creditCard: newCardInfo);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  void isSaveInputCard(bool isSave) {
    final newUiState = ref.read(_uiStateProvider).copyWith(isSaveCardInfo: isSave);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  void setSampleCard(CreditCard selectCard) {
    final newUiState = ref.read(_uiStateProvider).copyWith(creditCard: selectCard);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }
}

final _uiStateProvider = StateProvider((_) => _UiState.create(null));

class _UiState {
  const _UiState._({
    required this.creditCard,
    required this.isSaveCardInfo,
  });

  factory _UiState.create(CreditCard? cardInfo) {
    return _UiState._(
      creditCard: cardInfo ?? CreditCard.init(),
      isSaveCardInfo: cardInfo != null ? true : false,
    );
  }

  final CreditCard creditCard;
  final bool isSaveCardInfo;

  bool isRegistered() {
    return creditCard.isRegistered;
  }

  _UiState copyWith({
    CreditCard? creditCard,
    bool? isSaveCardInfo,
  }) {
    return _UiState._(
      creditCard: creditCard ?? this.creditCard,
      isSaveCardInfo: isSaveCardInfo ?? this.isSaveCardInfo,
    );
  }
}

final inputCreditCardProvider = Provider<CreditCard>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.creditCard));
});

final isSaveCreditCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSaveCardInfo));
});

final defaultCardInfoListProvider = Provider<List<(String, CreditCard)>>((_) {
  return [
    (
      'サンプルカード（正常）',
      const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '12/25', cardHolderName: 'TEST HOGE', cvvCode: '123', isRegistered: false)
    ),
    (
      'サンプルカード（エラー）',
      const CreditCard(cardNumber: '9999 8888 7777 6666', expiryDate: '04/25', cardHolderName: 'ERROR HOGE', cvvCode: '999', isRegistered: false)
    ),
    (
      'サンプルカード（警告）',
      const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '01/25', cardHolderName: 'WARNING HOGE', cvvCode: '455', isRegistered: false)
    ),
  ];
});

final enablePaymentButtonProvider = Provider<bool>((ref) {
  final inputCard = ref.watch(inputCreditCardProvider);
  if (inputCard.cardNumber.length != 19) {
    return false;
  }
  if (inputCard.expiryDate.length != 5) {
    return false;
  }
  if (inputCard.cvvCode.length != 3) {
    return false;
  }
  if (inputCard.cardHolderName.isEmpty) {
    return false;
  }
  return true;
});
