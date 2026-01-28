import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_movement_model.dart';

abstract class FinanceRecurrenceMovementRepository {
  Future<List<FinanceRecurrenceMovementModel>> getAll();
  Future<List<FinanceRecurrenceMovementModel>> getByRecurrenceId(int recurrenceId);
  Future<FinanceRecurrenceMovementModel> getById(int id);
  Future<int> create(FinanceRecurrenceMovementModel model);
  Future<void> update(FinanceRecurrenceMovementModel model);
  Future<void> delete(int id);
  Future<List<FinanceRecurrenceMovementModel>> getMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
