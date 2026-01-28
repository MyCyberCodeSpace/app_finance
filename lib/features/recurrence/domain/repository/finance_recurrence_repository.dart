import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';

abstract class FinanceRecurrenceRepository {
  Future<List<FinanceRecurrenceModel>> getAll();
  Future<List<FinanceRecurrenceModel>> getActive();
  Future<FinanceRecurrenceModel> getById(int id);
  Future<int> create(FinanceRecurrenceModel model);
  Future<void> update(FinanceRecurrenceModel model);
  Future<void> delete(int id);
  Future<void> toggleActive(int id, bool isActive);
  Future<List<FinanceRecurrenceModel>> getExpiredRecurrences();
}
