import 'package:finance_control/core/domain/params/finance_record_params.dart';
import 'package:finance_control/core/model/finance_record_model.dart';

abstract class FinanceRecordBlocEvent {}

class LoadFinanceRecordsEvent extends FinanceRecordBlocEvent {
  final FinanceRecordParams? params;
  LoadFinanceRecordsEvent({this.params});
}

class CreateFinanceRecordEvent extends FinanceRecordBlocEvent {
  final FinanceRecordModel record;

  CreateFinanceRecordEvent(this.record);
}

class UpdateFinanceRecordEvent extends FinanceRecordBlocEvent {
  final FinanceRecordModel record;

  UpdateFinanceRecordEvent(this.record);
}

class DeleteFinanceRecordEvent extends FinanceRecordBlocEvent {
  final int id;

  DeleteFinanceRecordEvent(this.id);
}
