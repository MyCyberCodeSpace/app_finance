import 'package:finance_control/features/saving/domain/model/finance_savings_model.dart';

final List<FinanceSavingsModel> initialDatasetFinanceSavings = [
  FinanceSavingsModel(
    id: 1,
    label: 'Poupança',
    value: 2500.00,
    updatedAt: DateTime(2026, 1, 10),
  ),
  FinanceSavingsModel(
    id: 2,
    label: 'Fundo de emergência',
    value: 10000.00,
    updatedAt: DateTime(2026, 1, 12),
  ),
  FinanceSavingsModel(
    id: 3,
    label: 'FII - HGLG11',
    value: 5000.00,
    updatedAt: DateTime(2026, 1, 15),
  ),
  FinanceSavingsModel(
    id: 4,
    label: 'Tesouro Selic',
    value: 3000.00,
    updatedAt: DateTime(2026, 1, 18),
  ),
  FinanceSavingsModel(
    id: 5,
    label: 'Investimento em ações',
    value: 12000.00,
    updatedAt: DateTime(2026, 1, 20),
  ),
];
