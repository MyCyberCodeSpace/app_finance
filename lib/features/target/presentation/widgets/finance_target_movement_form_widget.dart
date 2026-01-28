import 'package:finance_control/core/presentation/widgets/date_picker_field_widget.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/target/presentation/controller/finance_target_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinanceTargetMovementFormWidget extends StatefulWidget {
  final FinanceTargetFormController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSelectDate;
  final VoidCallback onSubmit;

  const FinanceTargetMovementFormWidget({
    super.key,
    required this.controller,
    required this.formKey,
    required this.onSelectDate,
    required this.onSubmit,
  });

  @override
  State<FinanceTargetMovementFormWidget> createState() =>
      _FinanceTargetMovementFormWidgetState();
}

class _FinanceTargetMovementFormWidgetState
    extends State<FinanceTargetMovementFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.3),
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
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 24,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Registrar Movimentação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Tipo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => widget.controller.selectedMovementType = 'entrada');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.controller.selectedMovementType == 'entrada'
                          ? AppColors.positiveBalance.withValues(alpha: 0.1)
                          : Colors.transparent,
                      side: BorderSide(
                        color: widget.controller.selectedMovementType == 'entrada'
                            ? AppColors.positiveBalance
                            : AppColors.gray.shade300,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward_rounded, color: AppColors.positiveBalance, size: 20),
                          const SizedBox(width: 8),
                          const Text('Entrada'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => widget.controller.selectedMovementType = 'saida');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.controller.selectedMovementType == 'saida'
                          ? AppColors.nevagativeBalance.withValues(alpha: 0.1)
                          : Colors.transparent,
                      side: BorderSide(
                        color: widget.controller.selectedMovementType == 'saida'
                            ? AppColors.nevagativeBalance
                            : AppColors.gray.shade300,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: AppColors.nevagativeBalance, size: 20),
                          const SizedBox(width: 8),
                          const Text('Saída'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text('Valor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray.shade700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller.movementValueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: 'R\$ ',
                prefixStyle: TextStyle(
                  color: widget.controller.selectedMovementType == 'entrada' ? AppColors.positiveBalance : AppColors.nevagativeBalance,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: (widget.controller.selectedMovementType == 'entrada' ? AppColors.positiveBalance : AppColors.nevagativeBalance).withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe o valor';
                final value = double.tryParse(v.replaceAll(',', '.'));
                if (value == null || value <= 0) return 'Informe um valor válido';
                return null;
              },
            ),

            const SizedBox(height: 16),

            DatePickerFieldWidget(
              controller: widget.controller.movementDateController,
              label: 'Data',
              hintText: 'Selecione uma data',
              icon: Icons.calendar_today,
              iconColor: AppColors.blue,
              onDateSelected: () => widget.onSelectDate.call(),
              validator: (v) => widget.controller.selectedMovementDate == null ? 'Selecione uma data' : null,
            ),

            const SizedBox(height: 16),

            Text('Descrição (Opcional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray.shade700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller.movementDescriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Ex: Depósito mensal, Saque para emergência...',
                filled: true,
                fillColor: AppColors.gray.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.add_rounded, size: 22), SizedBox(width: 8), Text('Registrar Movimentação', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))]),
            ),
          ],
        ),
      ),
    );
  }
}
