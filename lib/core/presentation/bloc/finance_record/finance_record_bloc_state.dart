import 'package:finance_control/core/model/finance_record_with_type_model.dart';

abstract class FinanceRecordBlocState {}

class FinanceRecordInitialState extends FinanceRecordBlocState {}

class FinanceRecordLoadingState extends FinanceRecordBlocState {}

class FinanceRecordLoadedState extends FinanceRecordBlocState {
  final List<FinanceRecordWithTypeModel> records;
  FinanceRecordLoadedState(this.records);
}

class FinanceRecordErrorState extends FinanceRecordBlocState {
  final String message;

  FinanceRecordErrorState(this.message);
}
