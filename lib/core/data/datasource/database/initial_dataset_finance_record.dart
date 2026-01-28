import 'package:finance_control/core/model/finance_record_model.dart';

final List<FinanceRecordModel> initialDataset = [
  FinanceRecordModel(
    id: 1,
    date: DateTime(2026, 1, 5),
    value: 1000.00,
    typeId: 1,
    description: 'Salário PJ',
    paymentId: 5,
  ),

  FinanceRecordModel(
    id: 2,
    date: DateTime(2026, 1, 8),
    value: 48.90,
    typeId: 2,
    description: 'Almoço no trabalho',
    paymentId: 3,
  ),

  FinanceRecordModel(
    id: 3,
    date: DateTime(2026, 1, 10),
    value: 1000.00,
    typeId: 3,
    description: 'Aluguel do apartamento',
    paymentId: 4,
  ),

  FinanceRecordModel(
    id: 4,
    date: DateTime(2026, 1, 10),
    value: 400.00,
    typeId: 4,
    description: 'Impostos da empresa (DAS)',
    paymentId: 4,
  ),

  FinanceRecordModel(
    id: 5,
    date: DateTime(2026, 1, 15),
    value: 1200.00,
    typeId: 5,
    description: 'Projeto mobile - Hotfix',
    paymentId: 5,
  ),

  FinanceRecordModel(
    id: 6,
    date: DateTime(2026, 1, 18),
    value: 120.50,
    typeId: 2,
    description: 'Mercado da semana',
    paymentId: 1,
  ),

  FinanceRecordModel(
    id: 7,
    date: DateTime(2026, 1, 20),
    value: 120.00,
    typeId: 2,
    description: 'Jantar fim de semana',
    paymentId: 1,
  ),

  FinanceRecordModel(
    id: 8,
    date: DateTime(2026, 1, 20),
    value: 122.00,
    typeId: 6,
    description: 'Compra do crédito',
    paymentId: 2,
  ),

  FinanceRecordModel(
    id: 9,
    date: DateTime(2026, 1, 25),
    value: 800.00,
    typeId: 7,
    description: 'Aporte em FII (HGLG11)',
    paymentId: 1,
  ),
];
