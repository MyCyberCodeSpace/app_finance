import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:finance_control/features/target/domain/model/finance_target_movement_model.dart';

abstract class FinanceTargetRepository {
  Future<List<FinanceTargetModel>> getAll();
  Future<FinanceTargetModel> getById(int id);
  Future<int> create(FinanceTargetModel model);
  Future<void> update(FinanceTargetModel model);
  Future<void> delete(int id);
  Future<double> totalTargetValue();

  // Movements
  Future<int> addMovement(FinanceTargetMovementModel movement);
  Future<List<FinanceTargetMovementModel>> getMovementsByTargetId(int targetId);
  Future<void> updateMovement(FinanceTargetMovementModel movement);
  Future<void> deleteMovement(int movementId);
  Future<double> getTotalMovementsByTargetId(int targetId);
}
