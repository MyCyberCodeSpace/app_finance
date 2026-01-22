import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/record/presentation/widget/list_status_widget.dart';
import 'package:flutter/material.dart';

class RecordRecurringCard extends StatelessWidget {
  final bool isRecurring;
  final Function(bool) onRecurringChanged;
  final TextEditingController dueDayController;
  final TextEditingController totalInstallmentsController;
  final Function(int?) onDueDayChanged;
  final ValueNotifier<int> statusId;
  final bool isEditMode;

  const RecordRecurringCard({
    super.key,
    required this.isRecurring,
    required this.onRecurringChanged,
    required this.dueDayController,
    required this.totalInstallmentsController,
    required this.onDueDayChanged,
    required this.statusId,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          SwitchListTile(
            value: isRecurring,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.nevagativeBalance.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.repeat_rounded,
                    color: AppColors.nevagativeBalance,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Despesa Recorrente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ex: cartão de crédito, parcelas',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.gray.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            activeThumbColor: AppColors.positiveBalance,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onChanged: onRecurringChanged,
          ),
          if (isRecurring) ...[
            Divider(height: 1, thickness: 1, color: AppColors.gray.shade200),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: dueDayController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 15, color: AppColors.gray.shade800),
                    decoration: InputDecoration(
                      labelText: 'Dia de vencimento',
                      hintText: 'Ex: 10',
                      labelStyle: TextStyle(fontSize: 14, color: AppColors.gray.shade600),
                      hintStyle: TextStyle(fontSize: 14, color: AppColors.gray.shade400),
                      filled: true,
                      fillColor: AppColors.gray.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray.shade200, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray.shade200, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.nevagativeBalance, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.nevagativeBalance, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: Icon(Icons.event_rounded, color: AppColors.orange, size: 20),
                    ),
                    validator: (v) {
                      if (isRecurring) {
                        final day = int.tryParse(v ?? '');
                        if (day == null || day < 1 || day > 31) {
                          return 'Informe um dia entre 1 e 31';
                        }
                      }
                      return null;
                    },
                    onChanged: (v) => onDueDayChanged(int.tryParse(v)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: totalInstallmentsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 15, color: AppColors.gray.shade800),
                    decoration: InputDecoration(
                      labelText: 'Total de parcelas',
                      hintText: 'Ex: 12',
                      labelStyle: TextStyle(fontSize: 14, color: AppColors.gray.shade600),
                      hintStyle: TextStyle(fontSize: 14, color: AppColors.gray.shade400),
                      filled: true,
                      fillColor: AppColors.gray.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray.shade200, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray.shade200, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.nevagativeBalance, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.nevagativeBalance, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: Icon(Icons.format_list_numbered_rounded, color: AppColors.blue, size: 20),
                    ),
                    validator: (v) {
                      if (isRecurring) {
                        final total = int.tryParse(v ?? '');
                        if (total == null || total <= 0) {
                          return 'Informe um número válido';
                        }
                      }
                      return null;
                    },
                  ),
                  if (isEditMode) ...[
                    const SizedBox(height: 16),
                    ListStatusWidget(statusId: statusId),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
