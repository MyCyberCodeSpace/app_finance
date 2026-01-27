import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_type_model.dart';

final initialFinanceTypes = [
  FinanceTypeModel(
    id: 1,
    name: 'Salário',
    financeCategory: FinanceCategory.income,
    icon: 'work',
    color: '#4CAF50',
    hasLimit: false,
    limitValue: 0,
  ),

  FinanceTypeModel(
    id: 2,
    name: 'Alimentação',
    financeCategory: FinanceCategory.expense,
    icon: 'restaurant',
    color: '#FF9800',
    hasLimit: true,
    limitValue: 500
  ),

  FinanceTypeModel(
    id: 3,
    name: 'Aluguel',
    financeCategory: FinanceCategory.expense,
    icon: 'home',
    color: '#F44336',
    hasLimit: true,
    limitValue: 1000,
  ),

  FinanceTypeModel(
    id: 4,
    name: 'Impostos',
    financeCategory: FinanceCategory.expense,
    icon: 'receipt_long',
    color: '#9C27B0',
    hasLimit: false,
    limitValue: 0,
  ),

  FinanceTypeModel(
    id: 5,
    name: 'Freelancer',
    financeCategory: FinanceCategory.income,
    icon: 'laptop_mac',
    color: '#2196F3',
    hasLimit: false,
    limitValue: 0
  ),

  FinanceTypeModel(
    id: 6,
    name: 'Pagamento da fatura do cartão',
    financeCategory: FinanceCategory.expense,
    icon: 'credit_card',
    color: '#3F51B5',
    hasLimit: true,
    limitValue: 500
  ),

  FinanceTypeModel(
    id: 7, 
    name: 'Fundo imobiliário',
    financeCategory: FinanceCategory.investiment,
    icon: 'monetization_on',
    color: '#3F51B5',
    hasLimit: false,
    limitValue: 0
  ),
];
