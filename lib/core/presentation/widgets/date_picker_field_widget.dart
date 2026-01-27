import 'package:finance_control/core/presentation/widgets/date_picker_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DatePickerFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function()? onDateSelected;

  const DatePickerFieldWidget({
    super.key,
    required this.controller,
    this.label = 'Data',
    this.hintText = 'Selecione uma data',
    this.icon = Icons.calendar_today,
    this.iconColor = AppColors.blue,
    this.readOnly = true,
    this.validator,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final datePickerField = DatePickerField();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.gray.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.gray.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.gray.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: iconColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onTap: () async {
            await datePickerField.selectDate(context, controller);
            onDateSelected?.call();
          },
        ),
      ],
    );
  }
}
