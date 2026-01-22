import 'package:finance_control/core/model/finance_savings_model.dart';

abstract class FinanceSavingsRepository {
  Future<List<FinanceSavingsModel>> getAll();
  Future<void> create(FinanceSavingsModel model);
  Future<void> update(FinanceSavingsModel model);
  Future<void> delete(int id);
  Future<FinanceSavingsModel> getById(int id);
  Future<double> getTotalSavings();
}
