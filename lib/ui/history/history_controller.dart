import 'package:creca_test/repository/payment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historiesProvider = FutureProvider.autoDispose((ref) async {
  return await ref.read(paymentRepositoryProvider).findHistories();
});
