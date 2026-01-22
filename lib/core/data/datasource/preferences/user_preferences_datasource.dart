import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesDatasource {
  static const _balanceVisibilityKey = 'balance_visibility';

  Future<bool> getBalanceVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_balanceVisibilityKey) ?? true;
  }

  Future<void> setBalanceVisibility(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_balanceVisibilityKey, value);
  }
}
