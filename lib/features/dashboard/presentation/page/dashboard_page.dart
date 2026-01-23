import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_state.dart';
import 'package:finance_control/core/presentation/controllers/finance_record_controller.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
import 'package:finance_control/features/dashboard/presentation/widget/current_balance_widget.dart';
import 'package:finance_control/features/dashboard/presentation/widget/dashboard_summary_widget.dart';
import 'package:finance_control/features/dashboard/presentation/widget/finance_record_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final FinanceRecordController financeRecordController;
  late final DashboardController dashboardController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    financeRecordController = Modular.get<FinanceRecordController>();
    dashboardController = Modular.get<DashboardController>();

    if (dashboardController.selectedFinanceType.value.isEmpty &&
        dashboardController.selectedFinanceCategory.value.isEmpty &&
        dashboardController.startDateTEC.text.isEmpty &&
        dashboardController.endDateTEC.text.isEmpty) {
      dashboardController.financeRecordBloc.add(
        LoadFinanceRecordsEvent(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: 0,
      onPressedFloatingActionButton: () {
        Modular.to.pushNamed('/record');
      },
      text: 'Dashboard',
      body: BlocConsumer<FinanceRecordBloc, FinanceRecordBlocState>(
        bloc: dashboardController.financeRecordBloc,
        listener: (context, state) {
          if (state is FinanceRecordLoadedState) {
            financeRecordController.getBalance();
          }
        },
        builder: (context, state) {
          if (state is FinanceRecordLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FinanceRecordErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is FinanceRecordLoadedState) {
            if (state.records.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        CurrentBalanceWidget(),
                        const SizedBox(height: 16),
                        DashboardSummaryWidget(),
                        _buildFilterSection(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: AppColors.gray.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum registro encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione seu primeiro registro!',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      CurrentBalanceWidget(),
                      const SizedBox(height: 16),
                      DashboardSummaryWidget(),
                      _buildFilterSection(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((
                    context,
                    index,
                  ) {
                    final item = state.records[index];
                    return FinanceRecordTile(
                      record: item.record,
                      type: item.type,
                    );
                  }, childCount: state.records.length),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      24,
                      16,
                      150,
                    ),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          side: BorderSide(
                            color: AppColors.gray.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          size: 20,
                          color: AppColors.gray.shade700,
                        ),
                        label: Text(
                          'Voltar ao Topo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ),
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

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 20,
              color: AppColors.gray.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Filtros',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray.shade700,
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: dashboardController.clearFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                side: BorderSide(
                  color: AppColors.gray.shade300,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                Icons.clear_rounded,
                size: 18,
                color: AppColors.gray.shade600,
              ),
              label: Text(
                'Limpar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => Modular.to.pushNamed('/filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text(
                'Selecionar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
