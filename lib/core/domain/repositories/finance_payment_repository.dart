import 'package:finance_control/core/model/finance_payment_model.dart';

abstract class FinancePaymentRepository {
  Future<List<FinancePaymentModel>> getAll();
  Future<void> create(FinancePaymentModel model);
  Future<void> update(FinancePaymentModel model);
  Future<void> delete(int id);
  Future<FinancePaymentModel> getById(int id);
}
