import 'package:finance_control/core/model/finance_payment_model.dart';

abstract class FinancePaymentBlocState {
  const FinancePaymentBlocState();
}

class FinancePaymentInitialState extends FinancePaymentBlocState {}

class FinancePaymentLoadingState extends FinancePaymentBlocState {}

class FinancePaymentLoadedState extends FinancePaymentBlocState {
  final List<FinancePaymentModel> listPayment;
  const FinancePaymentLoadedState(this.listPayment);
}

class FinancePaymentErrorState extends FinancePaymentBlocState {
  final String message;
  const FinancePaymentErrorState(this.message);
}
