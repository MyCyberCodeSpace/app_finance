import 'package:bloc/bloc.dart';
import 'package:finance_control/features/target/domain/repository/finance_target_repository.dart';
import 'finance_target_bloc_event.dart';
import 'finance_target_bloc_state.dart';

class FinanceTargetBloc
    extends Bloc<FinanceTargetBlocEvent, FinanceTargetBlocState> {
  final FinanceTargetRepository repository;

  FinanceTargetBloc(this.repository)
      : super(FinanceTargetInitialState()) {
    on<LoadFinanceTargetEvent>(_onLoad);
    on<CreateFinanceTargetEvent>(_onCreate);
    on<UpdateFinanceTargetEvent>(_onUpdate);
    on<DeleteFinanceTargetEvent>(_onDelete);
    on<LoadTotalTargetEvent>(_onLoadTotal);
  }

  Future<void> _onLoad(
    LoadFinanceTargetEvent event,
    Emitter<FinanceTargetBlocState> emit,
  ) async {
    emit(FinanceTargetLoadingState());
    try {
      final listTargets = await repository.getAll();
      emit(FinanceTargetLoadedState(listTargets));
    } catch (e) {
      emit(FinanceTargetErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinanceTargetEvent event,
    Emitter<FinanceTargetBlocState> emit,
  ) async {
    try {
      await repository.create(event.financeTarget);
      final listTargets = await repository.getAll();
      emit(FinanceTargetLoadedState(listTargets));
    } catch (e) {
      emit(FinanceTargetErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinanceTargetEvent event,
    Emitter<FinanceTargetBlocState> emit,
  ) async {
    try {
      await repository.update(event.financeTarget);
      final listTargets = await repository.getAll();
      emit(FinanceTargetLoadedState(listTargets));
    } catch (e) {
      emit(FinanceTargetErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinanceTargetEvent event,
    Emitter<FinanceTargetBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final listTargets = await repository.getAll();
      emit(FinanceTargetLoadedState(listTargets));
    } catch (e) {
      emit(FinanceTargetErrorState(e.toString()));
    }
  }

  Future<void> _onLoadTotal(
    LoadTotalTargetEvent event,
    Emitter<FinanceTargetBlocState> emit,
  ) async {
    emit(FinanceTargetLoadingState());
    try {
      final total = await repository.totalTargetValue();
      emit(FinanceTargetTotalLoadedState(total));
    } catch (e) {
      emit(FinanceTargetErrorState(e.toString()));
    }
  }
}
