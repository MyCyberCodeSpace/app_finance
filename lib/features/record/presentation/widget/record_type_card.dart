import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';
import 'package:finance_control/core/presentation/widgets/popup_select_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordTypeCard extends StatelessWidget {
  final FinanceTypeBloc financeTypeBloc;
  final int? selectedTypeId;
  final Function(int) onTypeChanged;

  const RecordTypeCard({
    super.key,
    required this.financeTypeBloc,
    required this.selectedTypeId,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.positiveBalance.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: AppColors.positiveBalance,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tipo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<FinanceTypeBloc, FinanceTypeBlocState>(
            bloc: financeTypeBloc,
            builder: (context, state) {
              if (state is FinanceTypeLoadingState) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is FinanceTypeErrorState) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.nevagativeBalance,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              if (state is FinanceTypeLoadedState) {
                if (state.types.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Nenhum tipo cadastrado',
                      style: TextStyle(
                        color: AppColors.gray.shade600,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                final effectiveTypeId = selectedTypeId ?? state.types.first.id!;

                return PopupSelectField<int>(
                  selectedValue: effectiveTypeId,
                  options: state.types.map((type) {
                    final isIncome = type.financeCategory.name == 'income';
                    final isExpense = type.financeCategory.name == 'expense';
                    final categoryColor = isIncome
                        ? AppColors.positiveBalance
                        : isExpense
                            ? AppColors.nevagativeBalance
                            : AppColors.orange;
                    final categoryIcon = isIncome
                        ? Icons.trending_up_rounded
                        : isExpense
                            ? Icons.trending_down_rounded
                            : Icons.show_chart_rounded;

                    return PopupSelectOption<int>(
                      value: type.id!,
                      label: type.name,
                      icon: categoryIcon,
                      color: categoryColor,
                    );
                  }).toList(),
                  onChanged: onTypeChanged,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
