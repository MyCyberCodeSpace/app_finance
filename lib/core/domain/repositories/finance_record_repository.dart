import 'package:finance_control/core/domain/params/finance_record_params.dart';
import 'package:finance_control/core/model/finance_record_model.dart';

abstract class FinanceRecordRepository {
  Future<List<FinanceRecordModel>> getAll(FinanceRecordParams params);
  Future<void> create(FinanceRecordModel model);
  Future<void> update(FinanceRecordModel model);
  Future<void> delete(int id);
  Future<double> getBalance();
  Future<void> setBalance(double value);
}
