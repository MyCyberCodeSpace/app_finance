import 'package:bloc/bloc.dart';
import 'package:finance_control/features/saving/domain/repository/finance_savings_repository.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_event.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_state.dart';

class FinanceSavingsBloc
    extends Bloc<FinanceSavingsBlocEvent, FinanceSavingsBlocState> {
  final FinanceSavingsRepository repository;

  FinanceSavingsBloc(this.repository)
    : super(FinanceSavingsInitialState()) {
    on<LoadFinanceSavingsEvent>(_onLoad);
    on<CreateFinanceSavingsEvent>(_onCreate);
    on<UpdateFinanceSavingsEvent>(_onUpdate);
    on<DeleteFinanceSavingsEvent>(_onDelete);
    on<LoadTotalSavingsEvent>(_onLoadTotal);
  }

  Future<void> _onLoad(
    LoadFinanceSavingsEvent event,
    Emitter<FinanceSavingsBlocState> emit,
  ) async {
    emit(FinanceSavingsLoadingState());
    try {
      final listSavings = await repository.getAll();
      emit(FinanceSavingsLoadedState(listSavings));
    } catch (e) {
      emit(FinanceSavingsErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinanceSavingsEvent event,
    Emitter<FinanceSavingsBlocState> emit,
  ) async {
    try {
      await repository.create(event.financeSavings);
      final listSavings = await repository.getAll();
      emit(FinanceSavingsLoadedState(listSavings));
    } catch (e) {
      emit(FinanceSavingsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinanceSavingsEvent event,
    Emitter<FinanceSavingsBlocState> emit,
  ) async {
    try {
      await repository.update(event.financeSavings);
      final listSavings = await repository.getAll();
      emit(FinanceSavingsLoadedState(listSavings));
    } catch (e) {
      emit(FinanceSavingsErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinanceSavingsEvent event,
    Emitter<FinanceSavingsBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final listSavings = await repository.getAll();
      emit(FinanceSavingsLoadedState(listSavings));
    } catch (e) {
      emit(FinanceSavingsErrorState(e.toString()));
    }
  }

  Future<void> _onLoadTotal(
    LoadTotalSavingsEvent event,
    Emitter<FinanceSavingsBlocState> emit,
  ) async {
    emit(FinanceSavingsLoadingState());
    try {
      final total = await repository.getTotalSavings();
      emit(FinanceSavingsTotalLoadedState(total));
    } catch (e) {
      emit(FinanceSavingsErrorState(e.toString()));
    }
  }
}
