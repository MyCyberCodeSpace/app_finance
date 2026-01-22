import 'package:flutter/foundation.dart';
import 'package:finance_control/core/data/datasource/preferences/user_preferences_datasource.dart';

class FinanceSharedPreferencesController {
  final UserPreferencesDatasource prefs;

  final ValueNotifier<bool> isBalanceVisible = ValueNotifier(true);

  FinanceSharedPreferencesController(this.prefs) {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    isBalanceVisible.value = await prefs.getBalanceVisibility();
  }

  Future<void> toggleVisibility() async {
    isBalanceVisible.value = !isBalanceVisible.value;
    await prefs.setBalanceVisibility(isBalanceVisible.value);
  }

  void dispose() {
    isBalanceVisible.dispose();
  }
}
