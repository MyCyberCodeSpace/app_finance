import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceRecurrenceMovementFormWidget extends StatefulWidget {
  final TextEditingController valueController;
  final TextEditingController descriptionController;
  final TextEditingController executionDateController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSelectDate;
  final VoidCallback onSubmit;
  final DateTime? selectedDate;

  const FinanceRecurrenceMovementFormWidget({
    super.key,
    required this.valueController,
    required this.descriptionController,
    required this.executionDateController,
    required this.formKey,
    required this.onSelectDate,
    required this.onSubmit,
    required this.selectedDate,
  });

  @override
  State<FinanceRecurrenceMovementFormWidget> createState() =>
      _FinanceRecurrenceMovementFormWidgetState();
}

class _FinanceRecurrenceMovementFormWidgetState
    extends State<FinanceRecurrenceMovementFormWidget> {
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
            color: AppColors.gray.shade300.withValues(
              alpha: 0.5,
            ),
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.autorenew_rounded,
                  size: 24,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Registrar Movimento de Recorrência',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Execution Date
            Text(
              'Data de Execução',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray.shade700,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.onSelectDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(widget.selectedDate!)
                            : 'Selecione uma data',
                        style: TextStyle(
                          color: widget.selectedDate != null
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
            const SizedBox(height: 16),

            // Value
            Text(
              'Valor (R\$)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.blue, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o valor';
                }
                if (double.tryParse(value) == null) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Descrição (opcional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Adicione uma descrição...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.blue, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Registrar Movimento',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
