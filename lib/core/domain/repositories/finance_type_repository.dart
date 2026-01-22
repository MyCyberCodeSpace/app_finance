
import 'package:finance_control/core/model/finance_type_model.dart';

abstract class FinanceTypeRepository {
  Future<List<FinanceTypeModel>> getAll();
  Future<void> create(FinanceTypeModel model);
  Future<void> update(FinanceTypeModel model);
  Future<void> delete(int id);
  Future<FinanceTypeModel> getById(int id);
}
