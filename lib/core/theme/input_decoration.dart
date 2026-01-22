import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppInputDecorations {
  static InputDecoration defaultDateDecoration({
    required String text,
  }) {
    return InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(color: AppColors.orange),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(
        Icons.calendar_month,
        color: AppColors.orange.shade300,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.orange),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.orange, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    );
  }
}
