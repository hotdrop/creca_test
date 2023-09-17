import 'package:isar/isar.dart';

part 'history.g.dart';

@collection
class History {
  Id id = Isar.autoIncrement;

  final int resultCode;

  final String message;

  @Index(type: IndexType.value)
  final DateTime dateTime;

  final String transactionId;

  final int amount;

  final String accountId;

  History(this.resultCode, this.message, this.dateTime, this.transactionId, this.amount, this.accountId);

  bool isSuccess() {
    return resultCode >= 200 && resultCode < 400;
  }
}
