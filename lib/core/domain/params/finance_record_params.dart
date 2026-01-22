import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_type_model.dart';

class FinanceRecordParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<FinanceCategory>? financeCategory;
  final List<FinanceTypeModel>? financeType;

  const FinanceRecordParams({
    this.startDate,
    this.endDate,
    this.financeCategory,
    this.financeType,
  });

  FinanceRecordParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<FinanceCategory>? financeCategory,
    List<FinanceTypeModel>? financeType,
  }) {
    return FinanceRecordParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      financeCategory: financeCategory ?? this.financeCategory,
      financeType: financeType ?? this.financeType,
    );
  }
}
