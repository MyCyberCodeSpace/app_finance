import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/features/recurrence/domain/enums/recurrence_type.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';

final initialDatasetFinanceRecurrence = [
  FinanceRecurrenceModel(
    id: 1,
    label: 'Salário',
    value: 5000.00,
    paymentId: 5,
    recurrenceType: RecurrenceType.monthly,
    dueDay: 5,
    startDate: DateTime(2026, 1, 5),
    description: 'Salário mensal',
    financeCategory: FinanceCategory.income,
  ),
  FinanceRecurrenceModel(
    id: 2,
    label: 'Aluguel',
    value: 1500.00,
    paymentId: 4,
    recurrenceType: RecurrenceType.monthly,
    dueDay: 10,
    startDate: DateTime(2026, 1, 10),
    description: 'Aluguel do apartamento',
    financeCategory: FinanceCategory.expense,
  ),
  FinanceRecurrenceModel(
    id: 3,
    label: 'Internet e Telefone',
    value: 120.00,
    paymentId: 2,
    recurrenceType: RecurrenceType.monthly,
    dueDay: 15,
    startDate: DateTime(2026, 1, 15),
    description: 'Conta de internet e telefone',
    financeCategory: FinanceCategory.expense,
  ),
];
