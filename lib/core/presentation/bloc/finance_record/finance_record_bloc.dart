import 'package:bloc/bloc.dart';
import 'package:finance_control/core/domain/params/finance_record_params.dart';
import 'package:finance_control/core/domain/repositories/finance_record_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/model/finance_record_with_type_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_state.dart';

class FinanceRecordBloc
    extends Bloc<FinanceRecordBlocEvent, FinanceRecordBlocState> {
  final FinanceRecordRepository recordRepository;
  final FinanceTypeRepository typeRepository;
  FinanceRecordParams _lastParams = FinanceRecordParams();

  FinanceRecordBloc(this.recordRepository, this.typeRepository)
    : super(FinanceRecordInitialState()) {
    on<LoadFinanceRecordsEvent>(_onLoad);
    on<CreateFinanceRecordEvent>(_onCreate);
    on<UpdateFinanceRecordEvent>(_onUpdate);
    on<DeleteFinanceRecordEvent>(_onDelete);
  }

  Future<List<FinanceRecordWithTypeModel>> _loadRecordsWithTypes() async {
    final records = await recordRepository.getAll(_lastParams);
    final types = await typeRepository.getAll();
    final typeMap = {for (final t in types) t.id!: t};

    return records.map((r) {
      return FinanceRecordWithTypeModel(
        record: r,
        type: typeMap[r.typeId]!,
      );
    }).toList();
  }

  Future<void> _onLoad(
    LoadFinanceRecordsEvent event,
    Emitter<FinanceRecordBlocState> emit,
  ) async {
    emit(FinanceRecordLoadingState());

    try {
      if (event.params != null) {
        _lastParams = event.params!;
      } else {
        _lastParams = FinanceRecordParams();
      }
      final result = await _loadRecordsWithTypes();

      emit(FinanceRecordLoadedState(result));
    } catch (e) {
      emit(FinanceRecordErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateFinanceRecordEvent event,
    Emitter<FinanceRecordBlocState> emit,
  ) async {
    try {
      await recordRepository.create(event.record);
      final result = await _loadRecordsWithTypes();
      emit(FinanceRecordLoadedState(result));
    } catch (e) {
      emit(FinanceRecordErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateFinanceRecordEvent event,
    Emitter<FinanceRecordBlocState> emit,
  ) async {
    try {
      await recordRepository.update(event.record);
      final result = await _loadRecordsWithTypes();
      emit(FinanceRecordLoadedState(result));
    } catch (e) {
      emit(FinanceRecordErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteFinanceRecordEvent event,
    Emitter<FinanceRecordBlocState> emit,
  ) async {
    try {
      await recordRepository.delete(event.id);
      final result = await _loadRecordsWithTypes();
      emit(FinanceRecordLoadedState(result));
    } catch (e) {
      emit(FinanceRecordErrorState(e.toString()));
    }
  }
}
