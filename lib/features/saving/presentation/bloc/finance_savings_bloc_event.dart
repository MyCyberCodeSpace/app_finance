import 'package:finance_control/features/saving/domain/model/finance_savings_model.dart';

abstract class FinanceSavingsBlocEvent {
  const FinanceSavingsBlocEvent();
}

class LoadFinanceSavingsEvent extends FinanceSavingsBlocEvent {}

class CreateFinanceSavingsEvent extends FinanceSavingsBlocEvent {
  final FinanceSavingsModel financeSavings;
  const CreateFinanceSavingsEvent(this.financeSavings);
}

class UpdateFinanceSavingsEvent extends FinanceSavingsBlocEvent {
  final FinanceSavingsModel financeSavings;
  const UpdateFinanceSavingsEvent(this.financeSavings);
}

class DeleteFinanceSavingsEvent extends FinanceSavingsBlocEvent {
  final int id;
  const DeleteFinanceSavingsEvent(this.id);
}

class LoadTotalSavingsEvent extends FinanceSavingsBlocEvent {}
