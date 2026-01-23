import 'package:finance_control/core/domain/params/finance_record_params.dart';
import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_record_with_type_model.dart';
import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/features/dashboard/models/dashboard_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DashboardController extends ChangeNotifier {
  final TextEditingController startDateTEC = TextEditingController();
  final TextEditingController endDateTEC = TextEditingController();
  final ValueNotifier<List<FinanceCategory>> selectedFinanceCategory =
      ValueNotifier<List<FinanceCategory>>([]);
  final ValueNotifier<List<FinanceTypeModel>> selectedFinanceType =
      ValueNotifier<List<FinanceTypeModel>>([]);

  final FinanceRecordBloc financeRecordBloc =
      Modular.get<FinanceRecordBloc>();

  void applyFilters() {
    DateTime? startDate = startDateTEC.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(startDateTEC.text)
        : null;

    DateTime? endDate = endDateTEC.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(endDateTEC.text)
        : null;

    financeRecordBloc.add(
      LoadFinanceRecordsEvent(
        params: FinanceRecordParams(
          startDate: startDate,
          endDate: endDate,
          financeCategory: selectedFinanceCategory.value,
          financeType: selectedFinanceType.value
        ),
      ),
    );
  }

  void toggleFinanceType(
    FinanceTypeModel financeType,
    bool selected,
  ) {
    final current = List<FinanceTypeModel>.from(
      selectedFinanceType.value,
    );

    if (selected) {
      current.add(financeType);
    } else {
      current.remove(financeType);
    }
    selectedFinanceType.value = current;
  }

  void toggleFinanceCategory(
    FinanceCategory financeCategory,
    bool selected,
  ) {
    final current = List<FinanceCategory>.from(
      selectedFinanceCategory.value,
    );

    if (selected) {
      current.add(financeCategory);
    } else {
      current.remove(financeCategory);
    }
    selectedFinanceCategory.value = current;
  }

  DashboardSummaryModel buildSummary(
    List<FinanceRecordWithTypeModel> records,
  ) {
    double income = 0;
    double expense = 0;
    double investment = 0;

    for (final item in records) {
      switch (item.type.financeCategory) {
        case FinanceCategory.income:
          income += item.record.value;
          break;
        case FinanceCategory.expense:
          expense += item.record.value;
          break;
        case FinanceCategory.investiment:
          investment += item.record.value;
          break;
      }
    }

    return DashboardSummaryModel(
      totalIncome: income,
      totalExpense: expense,
      totalInvestment: investment,
      growth: income - expense,
    );
  }

  Map<String, double> groupByType(
    List<FinanceRecordWithTypeModel> records,
  ) {
    final map = <String, double>{};

    for (final item in records) {
      map.update(
        item.type.name,
        (value) => value + item.record.value,
        ifAbsent: () => item.record.value,
      );
    }

    return map;
  }

  void clearFilters() {
    startDateTEC.clear();
    endDateTEC.clear();
    selectedFinanceCategory.value = [];
    selectedFinanceType.value = [];
    financeRecordBloc.add(LoadFinanceRecordsEvent());
  }

  void applyFilterByType(FinanceTypeModel financeType) {
    startDateTEC.clear();
    endDateTEC.clear();
    selectedFinanceCategory.value = [];
    selectedFinanceType.value = [financeType];
    
    financeRecordBloc.add(
      LoadFinanceRecordsEvent(
        params: FinanceRecordParams(
          financeType: [financeType],
        ),
      ),
    );
  }
}
