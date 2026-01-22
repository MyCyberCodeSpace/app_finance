import 'package:finance_control/core/model/finance_status_model.dart';

abstract class FinanceStatusBlocState {
  const FinanceStatusBlocState();
}

class FinanceStatusInitialState extends FinanceStatusBlocState {}

class FinanceStatusLoadingState extends FinanceStatusBlocState {}

class FinanceStatusLoadedState extends FinanceStatusBlocState {
  final List<FinanceStatusModel> listStatus;
  const FinanceStatusLoadedState(this.listStatus);
}

class FinanceStatusErrorState extends FinanceStatusBlocState {
  final String message;
  const FinanceStatusErrorState(this.message);
}
