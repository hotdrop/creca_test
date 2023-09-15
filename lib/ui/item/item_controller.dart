import 'package:creca_test/repository/payment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:creca_test/model/item.dart';

part 'item_controller.g.dart';

@riverpod
class ItemController extends _$ItemController {
  @override
  void build() {}

  List<Item> findAll() {
    return ref.read(paymentRepositoryProvider).findItems();
  }
}
