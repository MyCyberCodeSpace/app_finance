import 'package:finance_control/features/target/domain/model/finance_target_model.dart';

final initialFinanceTarget = [
  FinanceTargetModel(
    id: 1,
    label: 'Férias na Europa',
    targetValue: 12000,
    currentValue: 3500,
    desiredDeposit: 500,
    recurrencyDays: 30,
    dueDate: DateTime(2026, 7, 1),
  ),
  FinanceTargetModel(
    id: 2,
    label: 'Comprar notebook',
    targetValue: 8000,
    currentValue: 2000,
    desiredDeposit: 400,
    recurrencyDays: 15,
    dueDate: DateTime(2026, 3, 15),
  ),
  FinanceTargetModel(
    id: 3,
    label: 'Fundo de emergência',
    targetValue: 15000,
    currentValue: 9000,
    desiredDeposit: 300,
    recurrencyDays: 30,
    dueDate: null,
  ),
  FinanceTargetModel(
    id: 4,
    label: 'Curso de Flutter',
    targetValue: 2000,
    currentValue: 500,
    desiredDeposit: 250,
    recurrencyDays: 7,
    dueDate: DateTime(2026, 2, 28),
  ),
  FinanceTargetModel(
    id: 5,
    label: 'Compra do carro',
    targetValue: 40000,
    currentValue: 10000,
    desiredDeposit: 1000,
    recurrencyDays: 30,
    dueDate: DateTime(2027, 12, 31),
  ),
];
