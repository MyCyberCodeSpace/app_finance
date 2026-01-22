enum FinanceCategory { income, expense, investiment }

extension FinanceCategoryX on FinanceCategory {
  String get label {
    switch (this) {
      case FinanceCategory.income:
        return 'Receita';
      case FinanceCategory.expense:
        return 'Despesa';
      case FinanceCategory.investiment:
        return 'Investimento';
    }
  }
}
