import 'package:finance_control/features/recurrence/domain/enums/recurrence_type.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';
import 'package:finance_control/core/presentation/widgets/confirm_delete_dialog.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/presentation/widgets/edit_delete_popup_menu.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/recurrence/presentation/bloc/finance_recurrence_bloc.dart';
import 'package:finance_control/features/recurrence/presentation/bloc/finance_recurrence_bloc_event.dart';
import 'package:finance_control/features/recurrence/presentation/bloc/finance_recurrence_bloc_state.dart';
import 'package:finance_control/features/recurrence/presentation/pages/finance_recurrence_form_page.dart';
import 'package:finance_control/features/recurrence/presentation/pages/finance_recurrence_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class FinanceRecurrencePage extends StatefulWidget {
  const FinanceRecurrencePage({super.key});

  @override
  State<FinanceRecurrencePage> createState() => _FinanceRecurrencePageState();
}

class _FinanceRecurrencePageState extends State<FinanceRecurrencePage> {
  late final FinanceRecurrenceBloc financeRecurrenceBloc;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    financeRecurrenceBloc = Modular.get<FinanceRecurrenceBloc>();
    financeRecurrenceBloc.add(LoadFinanceRecurrencesEvent());
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => selectedStartDate = picked);
      _applyFilter();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => selectedEndDate = picked);
      _applyFilter();
    }
  }

  void _applyFilter() {
    financeRecurrenceBloc.add(
      FilterFinanceRecurrencesEvent(
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      ),
    );
  }

  void _clearFilter() {
    setState(() {
      selectedStartDate = null;
      selectedEndDate = null;
    });
    financeRecurrenceBloc.add(LoadFinanceRecurrencesEvent());
  }

  void _navigateToForm({FinanceRecurrenceModel? recurrence}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FinanceRecurrenceFormPage(recurrence: recurrence),
      ),
    ).then((_) {
      financeRecurrenceBloc.add(LoadFinanceRecurrencesEvent());
    });
  }

  Future<void> _confirmDelete(FinanceRecurrenceModel model) async {
    await ConfirmDeleteDialog.show(
      context: context,
      title: 'Excluir Recorrência',
      content: 'Tem certeza que deseja excluir esta recorrência? '
          'Essa ação não pode ser desfeita.',
      onConfirm: () {
        financeRecurrenceBloc.add(DeleteFinanceRecurrenceEvent(model.id!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: -1,
      text: 'Despesas/Receitas Recorrentes',
      onPressedFloatingActionButton: () => _navigateToForm(),
      body: BlocConsumer<FinanceRecurrenceBloc, FinanceRecurrenceBlocState>(
        bloc: financeRecurrenceBloc,
        listener: (context, state) {
          if (state is FinanceRecurrenceErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          List<FinanceRecurrenceModel> recurrences = [];
          
          if (state is FinanceRecurrenceLoadedState) {
            recurrences = state.listRecurrences;
          } else if (state is FinanceRecurrenceFilteredState) {
            recurrences = state.filteredRecurrences;
          }

          if (state is FinanceRecurrenceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildFilterSection(context),
              ),
              if (recurrences.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.repeat_rounded,
                          size: 80,
                          color: AppColors.gray.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma recorrência encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recurrence = recurrences[index];
                        return _buildRecurrenceCard(context, recurrence);
                      },
                      childCount: recurrences.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
          Text(
            'Filtrar por período',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: AppColors.gray.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedStartDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(selectedStartDate!)
                                : 'Data inicial',
                            style: TextStyle(
                              color: selectedStartDate != null
                                  ? AppColors.gray.shade800
                                  : AppColors.gray.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: AppColors.gray.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedEndDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(selectedEndDate!)
                                : 'Data final',
                            style: TextStyle(
                              color: selectedEndDate != null
                                  ? AppColors.gray.shade800
                                  : AppColors.gray.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (selectedStartDate != null || selectedEndDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _clearFilter,
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Limpar Filtro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray.shade300,
                    foregroundColor: AppColors.gray.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecurrenceCard(
    BuildContext context,
    FinanceRecurrenceModel recurrence,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FinanceRecurrenceHistoryPage(recurrence: recurrence),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recurrence.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recurrence.financeCategory.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.gray.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    EditDeletePopupMenu(
                      onEdit: () => _navigateToForm(recurrence: recurrence),
                      onDelete: () => _confirmDelete(recurrence),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valor',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray.shade600,
                              ),
                            ),
                            Text(
                              'R\$ ${recurrence.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recorrência',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray.shade600,
                              ),
                            ),
                            Text(
                              recurrence.recurrenceType.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.gray.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'De: ${DateFormat('dd/MM/yyyy').format(recurrence.startDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (recurrence.endDate != null) ...[
                      Icon(
                        Icons.event_available_outlined,
                        size: 14,
                        color: AppColors.gray.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Até: ${DateFormat('dd/MM/yyyy').format(recurrence.endDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        recurrence.isActive ? 'Ativa' : 'Inativa',
                        style: TextStyle(
                          fontSize: 12,
                          color: recurrence.isActive ? Colors.white : AppColors.gray.shade600,
                        ),
                      ),
                      backgroundColor: recurrence.isActive
                          ? AppColors.positiveBalance
                          : AppColors.gray.shade300,
                    ),
                    const SizedBox(width: 8),
                    if (recurrence.description != null)
                      Expanded(
                        child: Text(
                          recurrence.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
