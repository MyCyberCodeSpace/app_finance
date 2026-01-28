import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_state.dart';
import 'package:finance_control/core/presentation/widgets/popup_select_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordPaymentCard extends StatelessWidget {
  final FinancePaymentBloc financePaymentBloc;
  final ValueNotifier<int> paymentId;
  final Function(int) onPaymentChanged;

  const RecordPaymentCard({
    super.key,
    required this.financePaymentBloc,
    required this.paymentId,
    required this.onPaymentChanged,
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
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Forma de Pagamento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<FinancePaymentBloc, FinancePaymentBlocState>(
            bloc: financePaymentBloc,
            builder: (context, state) {
              if (state is FinancePaymentLoadingState) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is FinancePaymentErrorState) {
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

              if (state is FinancePaymentLoadedState) {
                if (state.listPayment.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Nenhuma forma de pagamento cadastrada',
                      style: TextStyle(
                        color: AppColors.gray.shade600,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                // Update payment ID if it's 0 (not set)
                if (paymentId.value == 0 && state.listPayment.isNotEmpty) {
                  Future.microtask(() {
                    paymentId.value = state.listPayment.first.id!;
                    onPaymentChanged(state.listPayment.first.id!);
                  });
                }

                return PopupSelectField<int>(
                  selectedValue: paymentId.value,
                  options: state.listPayment.map((payment) {
                    IconData icon;
                    Color color;

                    switch (payment.paymentName.toLowerCase()) {
                      case 'dinheiro':
                        icon = Icons.money_rounded;
                        color = AppColors.positiveBalance;
                        break;
                      case 'cartão de crédito':
                      case 'credito':
                      case 'crédito':
                        icon = Icons.credit_card_rounded;
                        color = AppColors.orange;
                        break;
                      case 'cartão de débito':
                      case 'debito':
                      case 'débito':
                        icon = Icons.credit_card_outlined;
                        color = AppColors.blue;
                        break;
                      case 'pix':
                        icon = Icons.pix_rounded;
                        color = AppColors.positiveBalance;
                        break;
                      case 'transferência':
                      case 'transferencia':
                        icon = Icons.compare_arrows_rounded;
                        color = AppColors.blue;
                        break;
                      default:
                        icon = Icons.payment_rounded;
                        color = AppColors.gray.shade700;
                    }

                    return PopupSelectOption<int>(
                      value: payment.id!,
                      label: payment.paymentName,
                      icon: icon,
                      color: color,
                    );
                  }).toList(),
                  onChanged: onPaymentChanged,
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
