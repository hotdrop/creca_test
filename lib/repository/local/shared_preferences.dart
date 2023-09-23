import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => SharedPrefs(ref));
final _sharedPreferencesProvider = Provider((ref) async => await SharedPreferences.getInstance());

class SharedPrefs {
  const SharedPrefs(this.ref);
  final Ref ref;

  // 簡易でローカル保存したいデータがあれば定義する
  Future<String> getItem() async => await _getString('key001');
  Future<void> saveItem(String value) async {
    await _saveString('key001', value);
  }

  Future<String> _getString(String key) async {
    final prefs = await ref.read(_sharedPreferencesProvider);
    return prefs.getString(key) ?? '';
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await ref.read(_sharedPreferencesProvider);
    prefs.setString(key, value);
  }
}
