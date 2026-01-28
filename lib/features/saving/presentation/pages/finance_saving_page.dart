import 'package:finance_control/features/saving/domain/model/finance_savings_model.dart';
import 'package:finance_control/core/presentation/widgets/confirm_delete_dialog.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/presentation/widgets/edit_delete_popup_menu.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_event.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_state.dart';
import 'package:finance_control/features/saving/presentation/pages/finance_saving_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class FinanceSavingPage extends StatefulWidget {
  const FinanceSavingPage({super.key});

  @override
  State<FinanceSavingPage> createState() => _FinanceSavingPageState();
}

class _FinanceSavingPageState extends State<FinanceSavingPage> {
  late final FinanceSavingsBloc financeSavingsBloc;

  @override
  void initState() {
    super.initState();
    financeSavingsBloc = Modular.get<FinanceSavingsBloc>();
    financeSavingsBloc.add(LoadFinanceSavingsEvent());
  }

  void _navigateToForm({FinanceSavingsModel? model}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FinanceSavingFormPage(saving: model),
      ),
    ).then((_) {
      financeSavingsBloc.add(LoadFinanceSavingsEvent());
    });
  }

  Future<void> _confirmDelete(FinanceSavingsModel model) async {
    await ConfirmDeleteDialog.show(
      context: context,
      title: 'Excluir Economia',
      content: 'Tem certeza que deseja excluir esta economia? '
          'Essa ação não pode ser desfeita.',
      onConfirm: () {
        financeSavingsBloc.add(DeleteFinanceSavingsEvent(model.id!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: 2,
      text: 'Minhas Economias',
      onPressedFloatingActionButton: () => _navigateToForm(),
      body: BlocConsumer<FinanceSavingsBloc, FinanceSavingsBlocState>(
        bloc: financeSavingsBloc,
        listener: (context, state) {
          if (state is FinanceSavingsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FinanceSavingsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FinanceSavingsLoadedState) {
            if (state.listSavings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 80,
                      color: AppColors.gray.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma economia cadastrada',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crie sua primeira economia!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final totalSavings = state.listSavings.length;
            final totalValue = state.listSavings.fold<double>(
              0,
              (sum, saving) => sum + saving.value,
            );

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(totalSavings, totalValue),
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
                        final savings = state.listSavings[index];
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
                              onTap: () => _navigateToForm(model: savings),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
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
                                                savings.label,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today_outlined,
                                                    size: 12,
                                                    color: AppColors.gray.shade600,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(savings.updatedAt),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.gray.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        EditDeletePopupMenu(
                                          onEdit: () => _navigateToForm(model: savings),
                                          onDelete: () => _confirmDelete(savings),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.positiveBalance,
                                            AppColors.positiveBalance
                                                .withValues(alpha: 0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Valor economizado',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'R\$ ${savings.value.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
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
                      childCount: state.listSavings.length,
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

  Widget _buildHeader(int totalSavings, double totalValue) {
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
                  Icons.savings_rounded,
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
                      'Total Economizado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Suas reservas financeiras',
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
                  '$totalSavings ${totalSavings == 1 ? 'Economia' : 'Economias'}',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valor Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${totalValue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
