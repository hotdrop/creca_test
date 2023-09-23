import 'package:creca_test/model/unique_id_generator.dart';
import 'package:creca_test/repository/account_repository.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:creca_test/model/credit_card.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<void> build() async {
    final registeredCreditCard = await ref.read(accountRepositoryProvider).findCreditCard();
    final transactionId = ref.read(uniqueIdGeneratorProvider).generate();
    if (registeredCreditCard != null) {
      ref.read(_uiStateProvider.notifier).state = _UiState.create(transactionId, registeredCreditCard);
    } else {
      ref.read(_uiStateProvider.notifier).state = _UiState.create(transactionId, CreditCardNewInput.init());
    }
  }

  ///
  /// カード情報入力
  ///
  void input(CreditCardModel? inputCardInfo) {
    if (inputCardInfo == null) {
      return;
    }

    final newCardInfo = CreditCardNewInput(
      cardNumber: inputCardInfo.cardNumber,
      expiryDate: inputCardInfo.expiryDate,
      cardHolderName: inputCardInfo.cardHolderName,
      cvvCode: inputCardInfo.cvvCode,
    );

    final newUiState = ref.read(_uiStateProvider).copyWith(creditCard: newCardInfo);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  ///
  /// 入力したカード情報を登録するか？
  ///
  void isSaveInputCard(bool isSave) {
    final newUiState = ref.read(_uiStateProvider).copyWith(isSaveCardInfo: isSave);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  ///
  /// サンプルカード設定
  ///
  void setSampleCard(CreditCard selectCard) {
    final newUiState = ref.read(_uiStateProvider).copyWith(creditCard: selectCard);
    ref.read(_uiStateProvider.notifier).state = newUiState;
  }

  ///
  /// カード情報を削除する
  ///
  Future<void> deleteCard() async {
    final creditCard = ref.read(_uiStateProvider).creditCard;
    switch (creditCard) {
      case CreditCardNewInput():
        return;
      case CreditCardRegistered():
        await ref.read(accountRepositoryProvider).deleteCreditCard(creditCard);
        final transactionId = ref.read(_uiStateProvider).transactionId;
        ref.read(_uiStateProvider.notifier).state = _UiState.create(transactionId, CreditCardNewInput.init());
    }
  }
}

final _uiStateProvider = StateProvider((_) => _UiState.create('', CreditCardNewInput.init()));

class _UiState {
  const _UiState._({
    required this.transactionId,
    required this.creditCard,
    required this.isSaveCardInfo,
  });

  factory _UiState.create(String transactionId, CreditCard cardInfo) {
    return _UiState._(
      transactionId: transactionId,
      creditCard: cardInfo,
      isSaveCardInfo: false,
    );
  }

  final String transactionId;
  final CreditCard creditCard;
  final bool isSaveCardInfo;

  _UiState copyWith({
    CreditCard? creditCard,
    bool? isSaveCardInfo,
  }) {
    return _UiState._(
      transactionId: transactionId,
      creditCard: creditCard ?? this.creditCard,
      isSaveCardInfo: isSaveCardInfo ?? this.isSaveCardInfo,
    );
  }
}

final paymentTransactionIdProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.transactionId));
});

final paymentInputCreditCardProvider = Provider<CreditCard>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.creditCard));
});

final paymentIsRegisteredCreditCardProvider = Provider<bool>((ref) {
  final card = ref.watch(_uiStateProvider.select((value) => value.creditCard));
  switch (card) {
    case CreditCardNewInput():
      return false;
    case CreditCardRegistered():
      return true;
  }
});

final paymentIsSaveCreditCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSaveCardInfo));
});

final defaultCardInfoListProvider = Provider<List<(String, CreditCard)>>((_) {
  return [
    ('サンプルカード（正常）', const CreditCardNewInput(cardNumber: '1111 2222 3333 4444', expiryDate: '12/25', cardHolderName: 'TEST HOGE', cvvCode: '123')),
    ('サンプルカード（エラー）', const CreditCardNewInput(cardNumber: '9999 8888 7777 6666', expiryDate: '04/25', cardHolderName: 'ERROR HOGE', cvvCode: '999')),
    ('サンプルカード（警告）', const CreditCardNewInput(cardNumber: '1111 2222 3333 4444', expiryDate: '01/25', cardHolderName: 'WARNING HOGE', cvvCode: '455')),
  ];
});

final paymentEnableButtonProvider = Provider<bool>((ref) {
  final card = ref.watch(paymentInputCreditCardProvider);
  switch (card) {
    case CreditCardNewInput():
      if (card.cardNumber.length != 19) {
        return false;
      }
      if (card.expiryDate.length != 5) {
        return false;
      }
      if (card.cvvCode.length != 3) {
        return false;
      }
      if (card.cardHolderName.isEmpty) {
        return false;
      }
      return true;
    case CreditCardRegistered():
      return true;
  }
});
