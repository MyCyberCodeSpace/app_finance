
import 'package:finance_control/core/model/finance_status_model.dart';

abstract class FinanceStatusBlocEvent {
  const FinanceStatusBlocEvent();
}

class LoadFinanceStatusEvent extends FinanceStatusBlocEvent {}

class CreateFinanceStatusEvent extends FinanceStatusBlocEvent {
  final FinanceStatusModel financeStatus;
  const CreateFinanceStatusEvent(this.financeStatus);
}

class UpdateFinanceStatusEvent extends FinanceStatusBlocEvent {
  final FinanceStatusModel financeStatus;
  const UpdateFinanceStatusEvent(this.financeStatus);
}

class DeleteFinanceStatusEvent extends FinanceStatusBlocEvent {
  final int id;
  const DeleteFinanceStatusEvent(this.id);
}
