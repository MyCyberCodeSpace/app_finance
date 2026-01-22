import 'package:bloc/bloc.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';

class FinanceTypeBloc extends Bloc<FinanceTypeBlocEvent, FinanceTypeBlocState> {
  final FinanceTypeRepository repository;

  FinanceTypeBloc(this.repository) : super(FinanceTypeInitialState()) {
    on<LoadFinanceTypesEvent>(_onLoad);
    on<CreateFinanceTypeEvent>(_onCreate);
    on<UpdateFinanceTypeEvent>(_onUpdate);
    on<DeleteFinanceTypeEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadFinanceTypesEvent event,
    Emitter<FinanceTypeBlocState> emit,
  ) async {
    emit(FinanceTypeLoadingState());
    try {
      final types = await repository.getAll();
      emit(FinanceTypeLoadedState(types));
    } catch (e) {
      emit(FinanceTypeErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinanceTypeEvent event,
    Emitter<FinanceTypeBlocState> emit,
  ) async {
    try {
      await repository.create(event.financeType);
      final types = await repository.getAll();
      emit(FinanceTypeLoadedState(types));
    } catch (e) {
      emit(FinanceTypeErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinanceTypeEvent event,
    Emitter<FinanceTypeBlocState> emit,
  ) async {
    try {
      await repository.update(event.financeType);
      final types = await repository.getAll();
      emit(FinanceTypeLoadedState(types));
    } catch (e) {
      emit(FinanceTypeErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinanceTypeEvent event,
    Emitter<FinanceTypeBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final types = await repository.getAll();
      emit(FinanceTypeLoadedState(types));
    } catch (e) {
      emit(FinanceTypeErrorState(e.toString()));
    }
  }
}
