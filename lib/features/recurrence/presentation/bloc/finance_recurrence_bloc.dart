import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_control/features/recurrence/domain/repository/finance_recurrence_repository.dart';
import 'finance_recurrence_bloc_event.dart';
import 'finance_recurrence_bloc_state.dart';

class FinanceRecurrenceBloc
    extends Bloc<FinanceRecurrenceBlocEvent, FinanceRecurrenceBlocState> {
  final FinanceRecurrenceRepository repository;

  FinanceRecurrenceBloc(this.repository)
      : super(FinanceRecurrenceInitialState()) {
    on<LoadFinanceRecurrencesEvent>(_onLoadRecurrences);
    on<CreateFinanceRecurrenceEvent>(_onCreateRecurrence);
    on<UpdateFinanceRecurrenceEvent>(_onUpdateRecurrence);
    on<DeleteFinanceRecurrenceEvent>(_onDeleteRecurrence);
    on<ToggleFinanceRecurrenceEvent>(_onToggleRecurrence);
    on<FilterFinanceRecurrencesEvent>(_onFilterRecurrences);
  }

  Future<void> _onLoadRecurrences(
    LoadFinanceRecurrencesEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      emit(FinanceRecurrenceLoadingState());
      final recurrences = await repository.getAll();
      emit(FinanceRecurrenceLoadedState(recurrences));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao carregar recorrências'));
    }
  }

  Future<void> _onCreateRecurrence(
    CreateFinanceRecurrenceEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      await repository.create(event.recurrence);
      final recurrences = await repository.getAll();
      emit(FinanceRecurrenceLoadedState(recurrences));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao criar recorrência'));
    }
  }

  Future<void> _onUpdateRecurrence(
    UpdateFinanceRecurrenceEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      await repository.update(event.recurrence);
      final recurrences = await repository.getAll();
      emit(FinanceRecurrenceLoadedState(recurrences));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao atualizar recorrência'));
    }
  }

  Future<void> _onDeleteRecurrence(
    DeleteFinanceRecurrenceEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final recurrences = await repository.getAll();
      emit(FinanceRecurrenceLoadedState(recurrences));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao deletar recorrência'));
    }
  }

  Future<void> _onToggleRecurrence(
    ToggleFinanceRecurrenceEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      await repository.toggleActive(event.id, event.isActive);
      final recurrences = await repository.getAll();
      emit(FinanceRecurrenceLoadedState(recurrences));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao alterar recorrência'));
    }
  }

  Future<void> _onFilterRecurrences(
    FilterFinanceRecurrencesEvent event,
    Emitter<FinanceRecurrenceBlocState> emit,
  ) async {
    try {
      emit(FinanceRecurrenceLoadingState());
      var recurrences = await repository.getAll();

      if (event.startDate != null || event.endDate != null) {
        recurrences = recurrences.where((r) {
          final isAfterStart = event.startDate == null ||
              r.startDate.isAfter(event.startDate!) ||
              r.startDate.isAtSameMomentAs(event.startDate!);
          final isBeforeEnd = event.endDate == null ||
              r.startDate.isBefore(event.endDate!) ||
              r.startDate.isAtSameMomentAs(event.endDate!);
          return isAfterStart && isBeforeEnd;
        }).toList();
      }

      emit(FinanceRecurrenceFilteredState(
        recurrences,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(FinanceRecurrenceErrorState('Erro ao filtrar recorrências'));
    }
  }
}
