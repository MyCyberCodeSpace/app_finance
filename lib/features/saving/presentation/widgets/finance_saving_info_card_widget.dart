import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/saving/presentation/controller/finance_saving_form_controller.dart';
import 'package:flutter/material.dart';

class FinanceSavingInfoCardWidget extends StatelessWidget {
  final FinanceSavingFormController controller;
  final VoidCallback onAdjustBalance;

  const FinanceSavingInfoCardWidget({
    super.key,
    required this.controller,
    required this.onAdjustBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gray.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade300.withValues(
              alpha: 0.5,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_outline,
                size: 20,
                color: AppColors.gray.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.labelController,
            decoration: InputDecoration(
              hintText:
                  'Ex: Reserva de emergência, Fundo de viagem...',
              filled: true,
              fillColor: AppColors.gray.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Informe a descrição'
                : null,
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 20,
                color: AppColors.positiveBalance,
              ),
              const SizedBox(width: 8),
              Text(
                'Valor Economizado',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.valueController,
            readOnly: true,
            keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: 'R\$ ',
              prefixStyle: TextStyle(
                color: AppColors.positiveBalance,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              suffixIcon: Icon(
                Icons.edit_rounded,
                color: AppColors.positiveBalance,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.positiveBalance
                  .withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onTap: onAdjustBalance,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Informe o valor';
              }
              final value = double.tryParse(
                v.replaceAll(',', '.'),
              );
              if (value == null || value < 0) {
                return 'Informe um valor válido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
