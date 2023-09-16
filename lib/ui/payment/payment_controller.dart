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

  void input(CreditCardModel? inputCardInfo) {
    if (inputCardInfo == null) {
      return;
    }

    final newCardInfo = CreditCard(
      cardNumber: inputCardInfo.cardNumber,
      expiryDate: inputCardInfo.expiryDate,
      cardHolderName: inputCardInfo.cardHolderName,
      cvvCode: inputCardInfo.cvvCode,
    );

    final newUiState = ref.read(_uiStateProvider).copyWith(inputCreditCard: newCardInfo);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  void isSaveInputCard(bool isSave) {
    final newUiState = ref.read(_uiStateProvider).copyWith(isSaveCardInfo: isSave);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  void setSampleCard(CreditCard selectCard) {
    final newUiState = ref.read(_uiStateProvider).copyWith(inputCreditCard: selectCard);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  Future<void> payment(int amount) async {
    final uiState = ref.read(_uiStateProvider);
    //  前回登録していない→今回登録する=カード情報を登録する
    //  前回登録している→今回登録しない=カード情報を消す
    await ref.read(paymentRepositoryProvider).payment(
          creditCard: uiState.inputCreditCard,
          amount: amount,
          isRegister: !uiState.isRegisteredCard && uiState.isSaveCardInfo,
          isRemove: uiState.isRegisteredCard && !uiState.isSaveCardInfo,
        );
  }
}

final _uiStateProvider = StateProvider((_) => _UiState.create(null));

class _UiState {
  const _UiState._({
    required this.registerCreditCard,
    required this.inputCreditCard,
    required this.isRegisteredCard,
    required this.isSaveCardInfo,
  });

  factory _UiState.create(CreditCard? cardInfo) {
    return _UiState._(
      registerCreditCard: cardInfo,
      inputCreditCard: cardInfo ?? CreditCard.init(),
      isRegisteredCard: cardInfo != null ? true : false,
      isSaveCardInfo: cardInfo != null ? true : false,
    );
  }

  final CreditCard? registerCreditCard;
  final CreditCard inputCreditCard;
  final bool isRegisteredCard;
  final bool isSaveCardInfo;

  _UiState copyWith({
    CreditCard? inputCreditCard,
    bool? isSaveCardInfo,
    bool? visibleCardInputArea,
  }) {
    return _UiState._(
      registerCreditCard: registerCreditCard,
      inputCreditCard: inputCreditCard ?? this.inputCreditCard,
      isRegisteredCard: isRegisteredCard,
      isSaveCardInfo: isSaveCardInfo ?? this.isSaveCardInfo,
    );
  }
}

final inputCreditCardProvider = Provider<CreditCard>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputCreditCard));
});

final isRegisteredCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isRegisteredCard));
});

final isSaveCreditCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSaveCardInfo));
});

final defaultCardInfoListProvider = Provider<List<(String, CreditCard)>>((_) {
  return [
    ('サンプルカード（正常）', const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '12/25', cardHolderName: 'TEST HOGE', cvvCode: '123')),
    ('サンプルカード（エラー）', const CreditCard(cardNumber: '9999 8888 7777 6666', expiryDate: '04/25', cardHolderName: 'ERROR HOGE', cvvCode: '999')),
    ('サンプルカード（警告）', const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '01/25', cardHolderName: 'WARNING HOGE', cvvCode: '455')),
  ];
});

final enablePaymentButtonProvider = Provider<bool>((ref) {
  final isRegister = ref.watch(isRegisteredCardProvider);
  final inputCard = ref.watch(inputCreditCardProvider);
  if (isRegister && inputCard.isEmpty()) {
    return true;
  }

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
