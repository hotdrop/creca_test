import 'package:creca_test/model/credit_card.dart';
import 'package:creca_test/model/item.dart';
import 'package:creca_test/repository/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'credit_controller.g.dart';

@riverpod
class CreditController extends _$CreditController {
  @override
  Future<void> build() async {
    final registeredCreditCard = await ref.read(paymentRepositoryProvider).findCreditCardInfo();
    if (registeredCreditCard != null) {
      final newUiState = _UiState.create(registeredCreditCard);
      ref.read(_uiStateProvider.notifier).state = newUiState;
    }
  }

  void changeVisibleInputArea() {
    final isVisible = ref.read(_uiStateProvider).visibleCardInputArea;
    final newUiState = ref.read(_uiStateProvider).copyWith(visibleCardInputArea: !isVisible);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  void input(CreditCardModel inputCardInfo) {
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

  Future<void> payment(Item item) async {
    final uiState = ref.read(_uiStateProvider);
    //  前回登録していない→今回登録する=カード情報を登録する
    //  前回登録している→今回登録しない=カード情報を消す
    await ref.read(paymentRepositoryProvider).payment(
          creditCard: uiState.inputCreditCard,
          amount: item.price,
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
    required this.visibleCardInputArea,
  });

  factory _UiState.create(CreditCard? cardInfo) {
    return _UiState._(
      registerCreditCard: cardInfo,
      inputCreditCard: cardInfo ?? CreditCard.init(),
      isRegisteredCard: cardInfo != null ? true : false,
      isSaveCardInfo: cardInfo != null ? true : false,
      visibleCardInputArea: cardInfo != null ? false : true,
    );
  }

  final CreditCard? registerCreditCard;
  final CreditCard inputCreditCard;
  final bool isRegisteredCard;
  final bool isSaveCardInfo;
  final bool visibleCardInputArea;

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
      visibleCardInputArea: visibleCardInputArea ?? this.visibleCardInputArea,
    );
  }
}

// クレカ情報入力ViewのKey
final creditCardInputValidateKey = StateProvider<GlobalKey<FormState>>((_) => GlobalKey<FormState>());

final inputCreditCardProvider = Provider<CreditCard>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputCreditCard));
});

final isRegisteredCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isRegisteredCard));
});

final isSaveCreditCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSaveCardInfo));
});

final visibleInputAreaProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.visibleCardInputArea));
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
