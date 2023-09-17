import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final uniqueIdGeneratorProvider = Provider((ref) => UniqueIdGenerator(ref));
final _uuidProvider = Provider((_) => const Uuid());

class UniqueIdGenerator {
  const UniqueIdGenerator(this.ref);

  final Ref ref;

  String generate() {
    return ref.read(_uuidProvider).v4();
  }
}
