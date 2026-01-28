import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:finance_control/core/presentation/widgets/confirm_delete_dialog.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/presentation/widgets/edit_delete_popup_menu.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc_event.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class FinanceTargetListPage extends StatefulWidget {
  const FinanceTargetListPage({super.key});

  @override
  State<FinanceTargetListPage> createState() =>
      _FinanceTargetListPageState();
}

class _FinanceTargetListPageState
    extends State<FinanceTargetListPage> {
  late final FinanceTargetBloc financeTargetBloc;

  @override
  void initState() {
    super.initState();
    financeTargetBloc = Modular.get<FinanceTargetBloc>();
    financeTargetBloc.add(LoadFinanceTargetEvent());
  }

  Future<void> _confirmDelete(
    BuildContext context,
    FinanceTargetModel target,
  ) async {
    await ConfirmDeleteDialog.show(
      context: context,
      title: 'Excluir Meta',
      content: 'Tem certeza que deseja excluir esta meta? '
          'Essa ação não pode ser desfeita.',
      onConfirm: () {
        financeTargetBloc.add(DeleteFinanceTargetEvent(target.id!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: 3,
      text: 'Metas',
      onPressedFloatingActionButton: () {
        Modular.to.pushNamed('/target/form');
      },
      body: BlocConsumer<FinanceTargetBloc, FinanceTargetBlocState>(
        bloc: financeTargetBloc,
        listener: (context, state) {
          if (state is FinanceTargetErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FinanceTargetLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FinanceTargetLoadedState) {
            if (state.listTargets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 80,
                      color: AppColors.gray.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma meta encontrada',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crie sua primeira meta!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final totalTargets = state.listTargets.length;
            final totalCurrent = state.listTargets.fold<double>(
              0,
              (sum, target) => sum + target.currentValue,
            );
            final totalGoal = state.listTargets.fold<double>(
              0,
              (sum, target) => sum + target.targetValue,
            );
            final overallProgress = totalGoal > 0 ? (totalCurrent / totalGoal).toDouble() : 0.0;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(
                    totalTargets,
                    totalCurrent,
                    totalGoal,
                    overallProgress,
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
                        final target = state.listTargets[index];
                        final progress =
                            (target.currentValue / target.targetValue)
                                .clamp(0.0, 1.0);
                        final progressPercent =
                            (progress * 100).toStringAsFixed(0);
                        final remaining =
                            target.targetValue - target.currentValue;

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
                          '/target/form',
                          arguments: target,
                        );
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
                                    color: AppColors.positiveBalance
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.flag_rounded,
                                    color: AppColors.positiveBalance,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        target.label,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Progresso: $progressPercent%',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.gray.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                EditDeletePopupMenu(
                                  onEdit: () {
                                    Modular.to.pushNamed(
                                      '/target/form',
                                      arguments: target,
                                    );
                                  },
                                  onDelete: () => _confirmDelete(context, target),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: _buildValueCard(
                                    'Atual',
                                    target.currentValue,
                                    AppColors.positiveBalance,
                                    Icons.attach_money,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildValueCard(
                                    'Meta',
                                    target.targetValue,
                                    AppColors.orange,
                                    Icons.flag_circle_outlined,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Faltam R\$ ${remaining.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.gray.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getProgressColor(progress)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '$progressPercent%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getProgressColor(progress),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor:
                                        AppColors.gray.shade200,
                                    color: _getProgressColor(progress),
                                    minHeight: 10,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.gray.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildDateInfo(
                                      'Iniciada',
                                      target.createdAt,
                                      Icons.calendar_today_outlined,
                                      AppColors.gray.shade700,
                                    ),
                                  ),
                                  if (target.dueDate != null) ...[
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: AppColors.gray.shade300,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                    Expanded(
                                      child: _buildDateInfo(
                                        'Prazo',
                                        target.dueDate!,
                                        Icons.event_outlined,
                                        _getDueDateColor(target.dueDate!),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: state.listTargets.length,
            ),
          ),
        ),
      ],
    );
  }

          if (state is FinanceTargetErrorState) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(
    int totalTargets,
    double totalCurrent,
    double totalGoal,
    double overallProgress,
  ) {
    final progressPercent = (overallProgress * 100).toStringAsFixed(1);
    final remaining = totalGoal - totalCurrent;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                  Icons.analytics_outlined,
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
                      'Resumo Geral',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Todas as suas metas',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalTargets ${totalTargets == 1 ? 'Meta' : 'Metas'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderCard(
                  'Investido',
                  'R\$ ${totalCurrent.toStringAsFixed(2)}',
                  Icons.savings_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderCard(
                  'Objetivo',
                  'R\$ ${totalGoal.toStringAsFixed(2)}',
                  Icons.flag_circle_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progresso Geral',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: overallProgress.clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  color: Colors.white,
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Faltam R\$ ${remaining.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(
    String label,
    DateTime date,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('dd/MM/yyyy').format(date),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.75) return AppColors.positiveBalance;
    if (progress >= 0.5) return AppColors.orange;
    return AppColors.nevagativeBalance;
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) return AppColors.nevagativeBalance;
    if (difference < 30) return AppColors.orange;
    return AppColors.positiveBalance;
  }
}
