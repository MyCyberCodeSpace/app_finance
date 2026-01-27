import 'package:finance_control/core/model/finance_savings_model.dart';
import 'package:finance_control/core/model/finance_saving_movement_model.dart';

abstract class FinanceSavingsRepository {
  Future<List<FinanceSavingsModel>> getAll();
  Future<void> create(FinanceSavingsModel model);
  Future<void> update(FinanceSavingsModel model);
  Future<void> delete(int id);
  Future<FinanceSavingsModel> getById(int id);
  Future<double> getTotalSavings();
  Future<int> addMovement(FinanceSavingMovementModel movement);
  Future<List<FinanceSavingMovementModel>> getMovementsBySavingId(int savingId);
  Future<void> updateMovement(FinanceSavingMovementModel movement);
  Future<void> deleteMovement(int movementId);
  Future<double> getTotalMovementsBySavingId(int savingId);
}
