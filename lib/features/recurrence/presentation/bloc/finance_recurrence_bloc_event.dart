import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';

abstract class FinanceRecurrenceBlocEvent {
  const FinanceRecurrenceBlocEvent();
}

class LoadFinanceRecurrencesEvent extends FinanceRecurrenceBlocEvent {}

class CreateFinanceRecurrenceEvent extends FinanceRecurrenceBlocEvent {
  final FinanceRecurrenceModel recurrence;
  const CreateFinanceRecurrenceEvent(this.recurrence);
}

class UpdateFinanceRecurrenceEvent extends FinanceRecurrenceBlocEvent {
  final FinanceRecurrenceModel recurrence;
  const UpdateFinanceRecurrenceEvent(this.recurrence);
}

class DeleteFinanceRecurrenceEvent extends FinanceRecurrenceBlocEvent {
  final int id;
  const DeleteFinanceRecurrenceEvent(this.id);
}

class ToggleFinanceRecurrenceEvent extends FinanceRecurrenceBlocEvent {
  final int id;
  final bool isActive;
  const ToggleFinanceRecurrenceEvent(this.id, this.isActive);
}

class FilterFinanceRecurrencesEvent extends FinanceRecurrenceBlocEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const FilterFinanceRecurrencesEvent({this.startDate, this.endDate});
}
