import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';

abstract class FinanceRecurrenceBlocState {
  const FinanceRecurrenceBlocState();
}

class FinanceRecurrenceInitialState extends FinanceRecurrenceBlocState {}

class FinanceRecurrenceLoadingState extends FinanceRecurrenceBlocState {}

class FinanceRecurrenceLoadedState extends FinanceRecurrenceBlocState {
  final List<FinanceRecurrenceModel> listRecurrences;
  const FinanceRecurrenceLoadedState(this.listRecurrences);
}

class FinanceRecurrenceFilteredState extends FinanceRecurrenceBlocState {
  final List<FinanceRecurrenceModel> filteredRecurrences;
  final DateTime? startDate;
  final DateTime? endDate;
  const FinanceRecurrenceFilteredState(
    this.filteredRecurrences, {
    this.startDate,
    this.endDate,
  });
}

class FinanceRecurrenceErrorState extends FinanceRecurrenceBlocState {
  final String message;
  const FinanceRecurrenceErrorState(this.message);
}
