import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_state.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DashboardSummaryWidget extends StatelessWidget {
  late final DashboardController dashboardController;
  DashboardSummaryWidget({super.key}) {
    dashboardController = Modular.get<DashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceRecordBloc, FinanceRecordBlocState>(
      bloc: dashboardController.financeRecordBloc,
      builder: (context, state) {
        if (state is FinanceRecordLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FinanceRecordErrorState) {
          return Center(child: Text(state.message));
        }

        if (state is FinanceRecordLoadedState) {
          if (state.records.isEmpty) {
            return const Center(
              child: Text('Nenhum registro encontrado'),
            );
          }

          final summary = dashboardController.buildSummary(
            state.records,
          );
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gray.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray.shade100,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                  splashColor: AppColors.gray.shade50,
                  highlightColor: AppColors.gray.shade50,
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  childrenPadding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: AppColors.blue,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Resumo Financeiro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray.shade800,
                    ),
                  ),
                  subtitle: Text(
                    'Ver detalhes do período',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray.shade500,
                    ),
                  ),
                  children: [
                    Column(
                      children: [
                        _row(
                          'Entradas',
                          summary.totalIncome,
                          AppColors.positiveBalance,
                        ),
                        Divider(
                          height: 24,
                          color: AppColors.gray.shade200,
                        ),
                        _row(
                          'Despesas',
                          summary.totalExpense,
                          AppColors.nevagativeBalance,
                        ),
                        Divider(
                          height: 24,
                          color: AppColors.gray.shade200,
                        ),
                        _row(
                          'Crescimento',
                          summary.growth,
                          AppColors.blue,
                        ),
                        if (summary.totalInvestment > 0) ...[
                          Divider(
                            height: 24,
                            color: AppColors.gray.shade200,
                          ),
                          _row(
                            'Investimentos',
                            summary.totalInvestment,
                            AppColors.orange,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _row(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade700,
          ),
        ),
        Text(
          NumberFormat.currency(
            locale: 'pt_BR',
            symbol: 'R\$',
          ).format(value),
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
