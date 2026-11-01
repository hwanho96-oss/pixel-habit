import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  String? readString(String key) => _prefs.getString(key);

  Future<void> writeString(String key, String value) {
    return _prefs.setString(key, value);
  }
}
