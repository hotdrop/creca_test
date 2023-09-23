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
    ref.read(_uiStateProvider.notifier).state = _UiState.create(transactionId, registeredCreditCard);
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

final _uiStateProvider = StateProvider((_) => _UiState.create('', null));

class _UiState {
  const _UiState._({
    required this.transactionId,
    required this.creditCard,
    required this.isRegisteredCardInfo,
    required this.isSaveCardInfo,
  });

  factory _UiState.create(String transactionId, CreditCard? cardInfo) {
    return _UiState._(
      transactionId: transactionId,
      creditCard: cardInfo ?? CreditCard.init(),
      isRegisteredCardInfo: cardInfo != null,
      isSaveCardInfo: cardInfo != null,
    );
  }

  final String transactionId;
  final CreditCard creditCard;
  final bool isRegisteredCardInfo;
  final bool isSaveCardInfo;

  _UiState copyWith({
    CreditCard? creditCard,
    bool? isSaveCardInfo,
  }) {
    return _UiState._(
      transactionId: transactionId,
      creditCard: creditCard ?? this.creditCard,
      isRegisteredCardInfo: isRegisteredCardInfo,
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
  return ref.watch(_uiStateProvider.select((value) => value.isRegisteredCardInfo));
});

final paymentIsSaveCreditCardProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSaveCardInfo));
});

final defaultCardInfoListProvider = Provider<List<(String, CreditCard)>>((_) {
  return [
    ('サンプルカード（正常）', const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '12/25', cardHolderName: 'TEST HOGE', cvvCode: '123')),
    ('サンプルカード（エラー）', const CreditCard(cardNumber: '9999 8888 7777 6666', expiryDate: '04/25', cardHolderName: 'ERROR HOGE', cvvCode: '999')),
    ('サンプルカード（警告）', const CreditCard(cardNumber: '1111 2222 3333 4444', expiryDate: '01/25', cardHolderName: 'WARNING HOGE', cvvCode: '455')),
  ];
});

final paymentEnableButtonProvider = Provider<bool>((ref) {
  final inputCard = ref.watch(paymentInputCreditCardProvider);
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
