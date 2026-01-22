import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';
import 'package:finance_control/core/presentation/controllers/finance_type_controller.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/presentation/widgets/date_picker_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
import 'package:finance_control/features/dashboard/presentation/widget/filter_expansion_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FiltersPage extends StatelessWidget {
  late final DashboardController dashboardController;
  late final FinanceTypeController financeTypeController;
  late final DatePickerField datePickerField;
  FiltersPage({super.key}) {
    dashboardController = Modular.get<DashboardController>();
    financeTypeController = Modular.get<FinanceTypeController>();
    datePickerField = DatePickerField();
    financeTypeController.financeTypeBloc.add(
      LoadFinanceTypesEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: 0,
      text: 'Selecione seus Filtros',
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        dashboardController.clearFilters();
                        Modular.to.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: AppColors.gray.shade300,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 20,
                        color: AppColors.gray.shade600,
                      ),
                      label: Text(
                        'Limpar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        dashboardController.applyFilters();
                        Modular.to.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.check_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Aplicar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilterExpansionCardWidget(
                title: 'Filtrar por período',
                icon: Icons.date_range,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dashboardController.startDateTEC,
                          readOnly: true,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray.shade800,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Data início',
                            labelStyle: TextStyle(
                              color: AppColors.gray.shade600,
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: AppColors.blue,
                            ),
                            filled: true,
                            fillColor: AppColors.gray.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.gray.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.gray.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.blue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onTap: () => datePickerField.selectDate(
                            context,
                            dashboardController.startDateTEC,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: dashboardController.endDateTEC,
                          readOnly: true,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray.shade800,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Data fim',
                            labelStyle: TextStyle(
                              color: AppColors.gray.shade600,
                            ),
                            prefixIcon: Icon(
                              Icons.event_outlined,
                              size: 20,
                              color: AppColors.blue,
                            ),
                            filled: true,
                            fillColor: AppColors.gray.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.gray.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.gray.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.blue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onTap: () => datePickerField.selectDate(
                            context,
                            dashboardController.endDateTEC,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilterExpansionCardWidget(
                title: 'Filtrar por Categoria',
                icon: Icons.category,
                children: [
                  ValueListenableBuilder<List<FinanceCategory>>(
                    valueListenable:
                        dashboardController.selectedFinanceCategory,
                    builder: (_, selected, __) {
                      return Column(
                        children: FinanceCategory.values
                            .map(
                              (financeCategory) {
                                final isIncome = financeCategory == FinanceCategory.income;
                                final isExpense = financeCategory == FinanceCategory.expense;
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

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: selected.contains(financeCategory)
                                        ? categoryColor.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selected.contains(financeCategory)
                                          ? categoryColor.withValues(alpha: 0.3)
                                          : AppColors.gray.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    secondary: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        categoryIcon,
                                        size: 20,
                                        color: categoryColor,
                                      ),
                                    ),
                                    title: Text(
                                      financeCategory.label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.gray.shade800,
                                      ),
                                    ),
                                    value: selected.contains(financeCategory),
                                    activeColor: categoryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onChanged: (value) {
                                      dashboardController.toggleFinanceCategory(
                                        financeCategory,
                                        value ?? false,
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilterExpansionCardWidget(
                title: 'Filtrar por tipo',
                icon: Icons.tune,
                children: [
                  ValueListenableBuilder(
                    valueListenable:
                        dashboardController.selectedFinanceType,
                    builder: (context, value, child) {
                      return ValueListenableBuilder<List<FinanceCategory>>(
                        valueListenable:
                            dashboardController.selectedFinanceCategory,
                        builder: (context, selectedCategories, _) {
                          return BlocBuilder<
                            FinanceTypeBloc,
                            FinanceTypeBlocState
                          >(
                            bloc: financeTypeController.financeTypeBloc,
                            builder: (context, state) {
                              if (state is FinanceTypeLoadingState) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is FinanceTypeLoadedState) {
                                var listType = state.types;
                                
                                if (selectedCategories.isNotEmpty) {
                                  listType = listType.where((type) {
                                    return selectedCategories.contains(type.financeCategory);
                                  }).toList();
                                }
                                
                                if (listType.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Center(
                                      child: Text(
                                        selectedCategories.isEmpty
                                            ? 'Nenhum tipo cadastrado'
                                            : 'Nenhum tipo encontrado para as categorias selecionadas',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.gray.shade600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                
                                return Column(
                                  children: listType
                                      .map(
                                        (financeType) {
                                          final isSelected = dashboardController
                                              .selectedFinanceType.value
                                              .contains(financeType);
                                          final isIncome = financeType.financeCategory == FinanceCategory.income;
                                          final isExpense = financeType.financeCategory == FinanceCategory.expense;
                                          final categoryColor = isIncome
                                              ? AppColors.positiveBalance
                                              : isExpense
                                                  ? AppColors.nevagativeBalance
                                                  : AppColors.orange;

                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? categoryColor.withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isSelected
                                                    ? categoryColor.withValues(alpha: 0.3)
                                                    : AppColors.gray.shade200,
                                                width: 1,
                                              ),
                                            ),
                                            child: CheckboxListTile(
                                              secondary: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: categoryColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  financeType.financeCategory.label.substring(0, 1),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: categoryColor,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                financeType.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.gray.shade800,
                                                ),
                                              ),
                                              subtitle: Text(
                                                financeType.financeCategory.label,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: categoryColor,
                                                ),
                                              ),
                                              value: isSelected,
                                              activeColor: categoryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              onChanged: (value) {
                                                dashboardController.toggleFinanceType(
                                                  financeType,
                                                  value ?? false,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                      .toList(),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onPressedFloatingActionButton: () {},
    );
  }
}
