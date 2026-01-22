import 'package:bloc/bloc.dart';

import 'package:finance_control/core/domain/repositories/finance_status_repository.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc_state.dart';

class FinanceStatusBloc
    extends Bloc<FinanceStatusBlocEvent, FinanceStatusBlocState> {
  final FinanceStatusRepository repository;

  FinanceStatusBloc(this.repository)
    : super(FinanceStatusInitialState()) {
    on<LoadFinanceStatusEvent>(_onLoad);
    on<CreateFinanceStatusEvent>(_onCreate);
    on<UpdateFinanceStatusEvent>(_onUpdate);
    on<DeleteFinanceStatusEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadFinanceStatusEvent event,
    Emitter<FinanceStatusBlocState> emit,
  ) async {
    emit(FinanceStatusLoadingState());
    try {
      final listStatus = await repository.getAll();
      emit(FinanceStatusLoadedState(listStatus));
    } catch (e) {
      emit(FinanceStatusErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinanceStatusEvent event,
    Emitter<FinanceStatusBlocState> emit,
  ) async {
    try {
      await repository.create(event.financeStatus);
      final listStatus = await repository.getAll();
      emit(FinanceStatusLoadedState(listStatus));
    } catch (e) {
      emit(FinanceStatusErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinanceStatusEvent event,
    Emitter<FinanceStatusBlocState> emit,
  ) async {
    try {
      await repository.update(event.financeStatus);
      final listStatus = await repository.getAll();
      emit(FinanceStatusLoadedState(listStatus));
    } catch (e) {
      emit(FinanceStatusErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinanceStatusEvent event,
    Emitter<FinanceStatusBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final status = await repository.getAll();
      emit(FinanceStatusLoadedState(status));
    } catch (e) {
      emit(FinanceStatusErrorState(e.toString()));
    }
  }
}
