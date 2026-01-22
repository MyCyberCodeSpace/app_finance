import 'package:finance_control/core/model/finance_status_model.dart';

abstract class FinanceStatusRepository {
  Future<List<FinanceStatusModel>> getAll();
  Future<void> create(FinanceStatusModel model);
  Future<void> update(FinanceStatusModel model);
  Future<void> delete(int id);
  Future<FinanceStatusModel> getById(int id);
}
