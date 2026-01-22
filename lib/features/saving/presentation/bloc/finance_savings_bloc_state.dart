import 'package:finance_control/core/model/finance_savings_model.dart';

abstract class FinanceSavingsBlocState {
  const FinanceSavingsBlocState();
}

class FinanceSavingsInitialState extends FinanceSavingsBlocState {}

class FinanceSavingsLoadingState extends FinanceSavingsBlocState {}

class FinanceSavingsLoadedState extends FinanceSavingsBlocState {
  final List<FinanceSavingsModel> listSavings;
  const FinanceSavingsLoadedState(this.listSavings);
}

class FinanceSavingsTotalLoadedState extends FinanceSavingsBlocState {
  final double totalSavings;
  const FinanceSavingsTotalLoadedState(this.totalSavings);
}

class FinanceSavingsErrorState extends FinanceSavingsBlocState {
  final String message;
  const FinanceSavingsErrorState(this.message);
}
