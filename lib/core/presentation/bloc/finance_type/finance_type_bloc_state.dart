import 'package:finance_control/core/model/finance_type_model.dart';

abstract class FinanceTypeBlocState {
  const FinanceTypeBlocState();
}

class FinanceTypeInitialState extends FinanceTypeBlocState {}

class FinanceTypeLoadingState extends FinanceTypeBlocState {}

class FinanceTypeLoadedState extends FinanceTypeBlocState {
  final List<FinanceTypeModel> types;
  const FinanceTypeLoadedState(this.types);
}

class FinanceTypeErrorState extends FinanceTypeBlocState {
  final String message;
  const FinanceTypeErrorState(this.message);
}
