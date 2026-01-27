import 'package:finance_control/core/domain/repositories/finance_savings_repository.dart';
import 'package:finance_control/core/model/finance_saving_movement_model.dart';
import 'package:finance_control/core/model/finance_savings_model.dart';
import 'package:flutter/material.dart';

class FinanceSavingFormController {
  final FinanceSavingsRepository savingsRepository;

  // Controllers
  late TextEditingController labelController;
  late TextEditingController valueController;
  late TextEditingController movementValueController;
  late TextEditingController movementDescriptionController;
  late TextEditingController movementDateController;

  // Estado
  String? selectedMovementType = 'entrada';
  DateTime? selectedMovementDate;

  FinanceSavingFormController({required this.savingsRepository});

  void initializeControllers({
    String? initialLabel = '',
    String? initialValue = '0.00',
  }) {
    labelController = TextEditingController(text: initialLabel);
    valueController = TextEditingController(text: initialValue);
    movementValueController = TextEditingController();
    movementDescriptionController = TextEditingController();
    movementDateController = TextEditingController();
  }

  void dispose() {
    labelController.dispose();
    valueController.dispose();
    movementValueController.dispose();
    movementDescriptionController.dispose();
    movementDateController.dispose();
  }

  Future<bool> addMovement(int savingId) async {
    try {
      final value = double.tryParse(
        movementValueController.text.replaceAll(',', '.'),
      );

      if (value == null || value <= 0) return false;
      if (selectedMovementDate == null || selectedMovementType == null) return false;

      final movement = FinanceSavingMovementModel(
        savingId: savingId,
        type: selectedMovementType!,
        value: value,
        description: movementDescriptionController.text.isEmpty
            ? null
            : movementDescriptionController.text,
        date: selectedMovementDate!,
      );

      await savingsRepository.addMovement(movement);

      // Atualizar saldo
      final currentValue = double.parse(valueController.text.replaceAll(',', '.'));
      final newValue = selectedMovementType == 'entrada'
          ? currentValue + value
          : currentValue - value;

      final updatedSaving = FinanceSavingsModel(
        id: savingId,
        label: labelController.text,
        value: newValue,
      );

      await savingsRepository.update(updatedSaving);
      valueController.text = newValue.toStringAsFixed(2);

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

  Future<bool> saveSaving(int? id) async {
    try {
      final value = double.tryParse(
        valueController.text.replaceAll(',', '.'),
      );

      if (value == null || value < 0) return false;
      if (labelController.text.isEmpty) return false;

      final savings = FinanceSavingsModel(
        id: id,
        label: labelController.text,
        value: value,
      );

      if (id != null) {
        await savingsRepository.update(savings);
      } else {
        await savingsRepository.create(savings);
      }

      return true;
    } catch (e) {
      throw Exception('Erro ao salvar poupança: $e');
    }
  }

  double getCurrentValue() {
    return double.tryParse(valueController.text.replaceAll(',', '.')) ?? 0.0;
  }

  void updateValue(double newValue) {
    valueController.text = newValue.toStringAsFixed(2);
  }
}
