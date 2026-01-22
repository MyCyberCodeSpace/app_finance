import 'package:finance_control/core/model/finance_record_model.dart';
import 'package:finance_control/core/model/finance_type_model.dart';

class FinanceRecordWithTypeModel {
  final FinanceRecordModel record;
  final FinanceTypeModel type;

  FinanceRecordWithTypeModel({
    required this.record,
    required this.type,
  });
}
