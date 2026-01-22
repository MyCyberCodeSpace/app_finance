import 'package:finance_control/core/model/finance_payment_model.dart';

abstract class FinancePaymentBlocEvent {
  const FinancePaymentBlocEvent();
}

class LoadFinancePaymentEvent extends FinancePaymentBlocEvent {}

class CreateFinancePaymentEvent extends FinancePaymentBlocEvent {
  final FinancePaymentModel financePayment;
  const CreateFinancePaymentEvent(this.financePayment);
}

class UpdateFinancePaymentEvent extends FinancePaymentBlocEvent {
  final FinancePaymentModel financePayment;
  const UpdateFinancePaymentEvent(this.financePayment);
}

class DeleteFinancePaymentEvent extends FinancePaymentBlocEvent {
  final int id;
  const DeleteFinancePaymentEvent(this.id);
}
