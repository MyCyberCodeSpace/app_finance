import 'package:finance_control/features/target/domain/model/finance_target_model.dart';

abstract class FinanceTargetRepository {
  Future<List<FinanceTargetModel>> getAll();
  Future<FinanceTargetModel> getById(int id);
  Future<int> create(FinanceTargetModel model);
  Future<void> update(FinanceTargetModel model);
  Future<void> delete(int id);
  Future<double> totalTargetValue(); 
}
