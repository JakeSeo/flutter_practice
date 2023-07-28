import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;

  factory LocalStorage() =>
      _instance ??= LocalStorage._(SharedPreferences.getInstance());

  LocalStorage._(this._storage);

  final Future<SharedPreferences> _storage;
  static const _userIdKey = 'USER-ID';

  Future<bool> hasUserId() async {
    var value = (await _storage).getString(_userIdKey);
    return value != null;
  }

  Future<String> getUserId() async {
    var value = (await _storage).getString(_userIdKey);

    if (value == null) {
      return '';
    }

    return value;
  }

  Future<bool> setUserId(String userId) async {
    return (await _storage).setString(_userIdKey, userId);
  }

  Future<bool> deleteUserId() async {
    return (await _storage).remove(_userIdKey);
  }
}
