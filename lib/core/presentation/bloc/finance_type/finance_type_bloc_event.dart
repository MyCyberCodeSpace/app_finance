import 'package:finance_control/core/model/finance_type_model.dart';

abstract class FinanceTypeBlocEvent {
  
  const FinanceTypeBlocEvent();
}

class LoadFinanceTypesEvent extends FinanceTypeBlocEvent {}

class CreateFinanceTypeEvent extends FinanceTypeBlocEvent {
  final FinanceTypeModel financeType;
  const CreateFinanceTypeEvent(this.financeType);
}

class UpdateFinanceTypeEvent extends FinanceTypeBlocEvent {
  final FinanceTypeModel financeType;
  const UpdateFinanceTypeEvent(this.financeType);
}

class DeleteFinanceTypeEvent extends FinanceTypeBlocEvent {
  final int id;
  const DeleteFinanceTypeEvent(this.id);
}
