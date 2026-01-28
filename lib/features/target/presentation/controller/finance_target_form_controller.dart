import 'package:finance_control/features/target/domain/repository/finance_target_repository.dart';
import 'package:finance_control/features/target/domain/model/finance_target_movement_model.dart';
import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:flutter/material.dart';

class FinanceTargetFormController {
  final FinanceTargetRepository targetRepository;

  // Controllers
  late TextEditingController labelController;
  late TextEditingController targetValueController;
  late TextEditingController currentValueController;
  late TextEditingController desiredDepositController;
  late TextEditingController recurrencyDaysController;

  // Movement controllers
  late TextEditingController movementValueController;
  late TextEditingController movementDescriptionController;
  late TextEditingController movementDateController;

  // State
  String? selectedMovementType = 'entrada';
  DateTime? selectedMovementDate;

  FinanceTargetFormController({required this.targetRepository});

  void initializeControllers({
    String? initialLabel = '',
    String? initialTargetValue = '0.00',
    String? initialCurrentValue = '0.00',
    String? initialDesiredDeposit = '0.00',
    String? initialRecurrencyDays = '30',
  }) {
    labelController = TextEditingController(text: initialLabel);
    targetValueController = TextEditingController(text: initialTargetValue);
    currentValueController = TextEditingController(text: initialCurrentValue);
    desiredDepositController = TextEditingController(text: initialDesiredDeposit);
    recurrencyDaysController = TextEditingController(text: initialRecurrencyDays);

    movementValueController = TextEditingController();
    movementDescriptionController = TextEditingController();
    movementDateController = TextEditingController();
  }

  void dispose() {
    labelController.dispose();
    targetValueController.dispose();
    currentValueController.dispose();
    desiredDepositController.dispose();
    recurrencyDaysController.dispose();
    movementValueController.dispose();
    movementDescriptionController.dispose();
    movementDateController.dispose();
  }

  Future<bool> addMovement(int targetId) async {
    try {
      final value = double.tryParse(
        movementValueController.text.replaceAll(',', '.'),
      );

      if (value == null || value <= 0) return false;
      if (selectedMovementDate == null || selectedMovementType == null) return false;

      final movement = FinanceTargetMovementModel(
        targetId: targetId,
        type: selectedMovementType!,
        value: value,
        description: movementDescriptionController.text.isEmpty
            ? null
            : movementDescriptionController.text,
        date: selectedMovementDate!,
      );

      await targetRepository.addMovement(movement);

      final currentValue = double.tryParse(
        currentValueController.text.replaceAll(',', '.'),
      ) ?? 0.0;
      final newValue = selectedMovementType == 'entrada'
          ? currentValue + value
          : currentValue - value;

      final updatedTarget = FinanceTargetModel(
        id: targetId,
        label: labelController.text,
        targetValue: double.tryParse(targetValueController.text.replaceAll(',', '.')) ?? 0.0,
        currentValue: newValue,
        desiredDeposit: double.tryParse(desiredDepositController.text.replaceAll(',', '.')) ?? 0.0,
        recurrencyDays: int.tryParse(recurrencyDaysController.text) ?? 30,
      );

      await targetRepository.update(updatedTarget);
      currentValueController.text = newValue.toStringAsFixed(2);

      clearMovementFields();
      return true;
    } catch (e) {
      throw Exception('Erro ao registrar movimentação: $e');
    }
  }

  void clearMovementFields() {
    movementValueController.clear();
    movementDescriptionController.clear();
    movementDateController.clear();
    selectedMovementDate = null;
    selectedMovementType = 'entrada';
  }

  void setMovementDate(DateTime date) {
    selectedMovementDate = date;
  }

  void setMovementType(String type) {
    selectedMovementType = type;
  }

  bool validateMovementForm() {
    return movementValueController.text.isNotEmpty &&
        selectedMovementDate != null &&
        selectedMovementType != null;
  }

  Future<bool> saveTarget(int? id) async {
    try {
      final targetValue = double.tryParse(
        targetValueController.text.replaceAll(',', '.'),
      );
      final currentValue = double.tryParse(
        currentValueController.text.replaceAll(',', '.'),
      );
      final desiredDeposit = double.tryParse(
        desiredDepositController.text.replaceAll(',', '.'),
      );
      final recurrencyDays = int.tryParse(recurrencyDaysController.text);

      if (targetValue == null || targetValue <= 0) return false;
      if (currentValue == null || currentValue < 0) return false;
      if (desiredDeposit == null || desiredDeposit <= 0) return false;
      if (recurrencyDays == null || recurrencyDays <= 0) return false;
      if (labelController.text.isEmpty) return false;

      final target = FinanceTargetModel(
        id: id,
        label: labelController.text,
        targetValue: targetValue,
        currentValue: currentValue,
        desiredDeposit: desiredDeposit,
        recurrencyDays: recurrencyDays,
      );

      if (id != null) {
        await targetRepository.update(target);
      } else {
        await targetRepository.create(target);
      }

      return true;
    } catch (e) {
      throw Exception('Erro ao salvar meta: $e');
    }
  }

  double getCurrentValue() {
    return double.tryParse(currentValueController.text.replaceAll(',', '.')) ?? 0.0;
  }

  void updateCurrentValue(double newValue) {
    currentValueController.text = newValue.toStringAsFixed(2);
  }
}
