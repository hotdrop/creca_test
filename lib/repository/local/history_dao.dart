import 'package:creca_test/model/account.dart';
import 'package:creca_test/model/history.dart';
import 'package:creca_test/model/payment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final historyDaoProvider = Provider((ref) => HistoryDao(ref));
final _isarProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([HistorySchema], directory: dir.path);
});

class HistoryDao {
  const HistoryDao(this.ref);

  final Ref ref;

  Future<List<History>> findAll() async {
    final isar = await ref.read(_isarProvider.future);
    return await isar.historys.where().sortByDateTimeDesc().findAll();
  }

  Future<void> save(Payment payment, int resultCode, String message) async {
    final isar = await ref.read(_isarProvider.future);
    final history = History(
      resultCode,
      message,
      DateTime.now(),
      payment.transactionId,
      payment.amount,
      ref.read(accountProvider).id,
    );

    await isar.writeTxn(() async {
      await isar.historys.put(history);
    });
  }
}
