import 'package:finance_control/core/model/finance_target_model.dart';

abstract class FinanceTargetBlocEvent {
  const FinanceTargetBlocEvent();
}

class LoadFinanceTargetEvent extends FinanceTargetBlocEvent {}

class CreateFinanceTargetEvent extends FinanceTargetBlocEvent {
  final FinanceTargetModel financeTarget;
  const CreateFinanceTargetEvent(this.financeTarget);
}

class UpdateFinanceTargetEvent extends FinanceTargetBlocEvent {
  final FinanceTargetModel financeTarget;
  const UpdateFinanceTargetEvent(this.financeTarget);
}

class DeleteFinanceTargetEvent extends FinanceTargetBlocEvent {
  final int id;
  const DeleteFinanceTargetEvent(this.id);
}

class LoadTotalTargetEvent extends FinanceTargetBlocEvent {}
