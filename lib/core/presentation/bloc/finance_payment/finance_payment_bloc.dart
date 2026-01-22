import 'package:bloc/bloc.dart';
import 'package:finance_control/core/domain/repositories/finance_payment_repository.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_state.dart';

class FinancePaymentBloc
    extends Bloc<FinancePaymentBlocEvent, FinancePaymentBlocState> {
  final FinancePaymentRepository repository;

  FinancePaymentBloc(this.repository)
    : super(FinancePaymentInitialState()) {
    on<LoadFinancePaymentEvent>(_onLoad);
    on<CreateFinancePaymentEvent>(_onCreate);
    on<UpdateFinancePaymentEvent>(_onUpdate);
    on<DeleteFinancePaymentEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadFinancePaymentEvent event,
    Emitter<FinancePaymentBlocState> emit,
  ) async {
    emit(FinancePaymentLoadingState());
    try {
      final listPayment = await repository.getAll();
      emit(FinancePaymentLoadedState(listPayment));
    } catch (e) {
      emit(FinancePaymentErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinancePaymentEvent event,
    Emitter<FinancePaymentBlocState> emit,
  ) async {
    try {
      await repository.create(event.financePayment);
      final listPayment = await repository.getAll();
      emit(FinancePaymentLoadedState(listPayment));
    } catch (e) {
      emit(FinancePaymentErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinancePaymentEvent event,
    Emitter<FinancePaymentBlocState> emit,
  ) async {
    try {
      await repository.update(event.financePayment);
      final listPayment = await repository.getAll();
      emit(FinancePaymentLoadedState(listPayment));
    } catch (e) {
      emit(FinancePaymentErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinancePaymentEvent event,
    Emitter<FinancePaymentBlocState> emit,
  ) async {
    try {
      await repository.delete(event.id);
      final payments = await repository.getAll();
      emit(FinancePaymentLoadedState(payments));
    } catch (e) {
      emit(FinancePaymentErrorState(e.toString()));
    }
  }
}
