import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';
import 'package:finance_control/core/presentation/widgets/confirm_delete_dialog.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/presentation/widgets/edit_delete_popup_menu.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FinanceTypeListPage extends StatefulWidget {
  const FinanceTypeListPage({super.key});

  @override
  State<FinanceTypeListPage> createState() => _FinanceTypeListPageState();
}

class _FinanceTypeListPageState extends State<FinanceTypeListPage> {
  late final FinanceTypeBloc financeTypeBloc;
  FinanceCategory? _filterFinanceCategory;

  @override
  void initState() {
    super.initState();
    financeTypeBloc = Modular.get<FinanceTypeBloc>();
    financeTypeBloc.add(LoadFinanceTypesEvent());
  }

  Future<void> _confirmDelete(int typeId) async {
    await ConfirmDeleteDialog.show(
      context: context,
      title: 'Excluir Tipo',
      content: 'Tem certeza que deseja excluir este tipo financeiro? '
          'Essa ação não pode ser desfeita.',
      onConfirm: () {
        financeTypeBloc.add(DeleteFinanceTypeEvent(typeId));
      },
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.positiveBalance.withValues(alpha: 0.2),
      checkmarkColor: AppColors.positiveBalance,
      backgroundColor: AppColors.gray.shade100,
      labelStyle: TextStyle(
        color: selected ? AppColors.positiveBalance : AppColors.gray.shade700,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? AppColors.positiveBalance : AppColors.gray.shade300,
          width: selected ? 1.5 : 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: 1,
      text: 'Tipos Financeiros',
      onPressedFloatingActionButton: () {
        Modular.to.pushNamed('/type/form').then((_) {
          financeTypeBloc.add(LoadFinanceTypesEvent());
        });
      },
      body: BlocConsumer<FinanceTypeBloc, FinanceTypeBlocState>(
        bloc: financeTypeBloc,
        listener: (context, state) {
          if (state is FinanceTypeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            financeTypeBloc.add(LoadFinanceTypesEvent());
          }
        },
        builder: (context, state) {
          if (state is FinanceTypeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FinanceTypeLoadedState) {
            final filtered = _filterFinanceCategory == null
                ? state.types
                : state.types
                    .where((t) => t.financeCategory == _filterFinanceCategory)
                    .toList();

            if (filtered.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 80,
                      color: AppColors.gray.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma categoria encontrada',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crie seu primeiro tipo financeiro!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.positiveBalance,
                          AppColors.positiveBalance.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.positiveBalance.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.category_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Categorias',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Gerencie seus tipos de transação',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Filtrar por tipo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildChip(
                              label: 'Todos',
                              selected: _filterFinanceCategory == null,
                              onSelected: () => setState(
                                () => _filterFinanceCategory = null,
                              ),
                            ),
                            _buildChip(
                              label: 'Receitas',
                              selected: _filterFinanceCategory == FinanceCategory.income,
                              onSelected: () => setState(
                                () => _filterFinanceCategory = FinanceCategory.income,
                              ),
                            ),
                            _buildChip(
                              label: 'Despesas',
                              selected: _filterFinanceCategory == FinanceCategory.expense,
                              onSelected: () => setState(
                                () => _filterFinanceCategory = FinanceCategory.expense,
                              ),
                            ),
                            _buildChip(
                              label: 'Investimentos',
                              selected: _filterFinanceCategory == FinanceCategory.investiment,
                              onSelected: () => setState(
                                () => _filterFinanceCategory = FinanceCategory.investiment,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final type = filtered[index];
                        final isIncome = type.financeCategory == FinanceCategory.income;
                        final isExpense = type.financeCategory == FinanceCategory.expense;
                        final categoryColor = isIncome
                            ? AppColors.positiveBalance
                            : isExpense
                                ? AppColors.nevagativeBalance
                                : AppColors.orange;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.gray.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gray.shade300.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Modular.to.pushNamed(
                                  '/type/form',
                                  arguments: type,
                                ).then((_) {
                                  financeTypeBloc.add(LoadFinanceTypesEvent());
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            isIncome
                                                ? Icons.trending_up_rounded
                                                : isExpense
                                                    ? Icons.trending_down_rounded
                                                    : Icons.show_chart_rounded,
                                            color: categoryColor,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                type.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: categoryColor.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      type.financeCategory.label,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: categoryColor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  if (!type.isActive) ...[
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.gray.shade200,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        'Inativo',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors.gray.shade600,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        EditDeletePopupMenu(
                                          onEdit: () {
                                            Modular.to.pushNamed(
                                              '/type/form',
                                              arguments: type,
                                            ).then((_) {
                                              financeTypeBloc.add(LoadFinanceTypesEvent());
                                            });
                                          },
                                          onDelete: () => _confirmDelete(type.id!),
                                        ),
                                      ],
                                    ),
                                    if (type.hasLimit) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.orange.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.orange.withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              size: 16,
                                              color: AppColors.orange,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Limite: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.orange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'R\$ ${type.limitValue.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
