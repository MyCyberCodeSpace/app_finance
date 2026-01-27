import 'package:finance_control/core/model/finance_savings_model.dart';
import 'package:finance_control/core/presentation/widgets/adjust_balance_dialog_widget.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_event.dart';
import 'package:finance_control/features/saving/presentation/controller/finance_saving_form_controller.dart';
import 'package:finance_control/features/saving/presentation/widgets/finance_movement_form_widget.dart';
import 'package:finance_control/features/saving/presentation/widgets/finance_saving_header_widget.dart';
import 'package:finance_control/features/saving/presentation/widgets/finance_saving_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class FinanceSavingFormPage extends StatefulWidget {
  final FinanceSavingsModel? saving;

  const FinanceSavingFormPage({super.key, this.saving});

  @override
  State<FinanceSavingFormPage> createState() =>
      _FinanceSavingFormPageState();
}

class _FinanceSavingFormPageState
    extends State<FinanceSavingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _movementFormKey = GlobalKey<FormState>();
  late final FinanceSavingFormController _controller;
  late final FinanceSavingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<FinanceSavingsBloc>();
    _controller = FinanceSavingFormController(
      savingsRepository: Modular.get(),
    );
    _controller.initializeControllers(
      initialLabel: widget.saving?.label ?? '',
      initialValue: widget.saving != null
          ? widget.saving!.value.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final value = double.tryParse(
        _controller.valueController.text.replaceAll(',', '.'),
      );
      if (value != null) {
        final savings = FinanceSavingsModel(
          id: widget.saving?.id,
          label: _controller.labelController.text,
          value: value,
        );

        if (widget.saving != null) {
          _bloc.add(UpdateFinanceSavingsEvent(savings));
        } else {
          _bloc.add(CreateFinanceSavingsEvent(savings));
        }

        Modular.to.pop();
      }
    }
  }

  Future<void> _selectMovementDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.selectedMovementDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _controller.selectedMovementDate = picked;
        _controller.movementDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(picked);
      });
    }
  }

  void _showAdjustBalanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AdjustBalanceDialog(
        currentBalance: double.tryParse(
              _controller.valueController.text.replaceAll(',', '.'),
            ) ??
            0.0,
        title: 'Ajustar Saldo',
        subtitle: 'Informe o novo valor economizado',
        accentColor: AppColors.positiveBalance,
        onConfirm: (value) {
          setState(() {
            _controller.valueController.text = value.toStringAsFixed(2);
          });
        },
      ),
    );
  }

  void _submitMovement() async {
    if (widget.saving == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Salve a poupança antes de adicionar movimentações',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_movementFormKey.currentState!.validate() &&
        _controller.selectedMovementDate != null &&
        _controller.selectedMovementType != null) {
      try {
        final result = await _controller.addMovement(
          widget.saving!.id!,
        );

        if (result) {
          setState(() {});

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Movimentação registrada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao registrar movimentação: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.saving != null;

    return Scaffold(
      backgroundColor: AppColors.gray.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Editar Economia' : 'Nova Economia',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FinanceSavingHeaderWidget(isEdit: isEdit),

              const SizedBox(height: 24),
              FinanceSavingInfoCardWidget(
                controller: _controller,
                onAdjustBalance: () => _showAdjustBalanceDialog(context),
              ),
              const SizedBox(height: 24),

              if (isEdit) ...[
                FinanceMovementFormWidget(
                  controller: _controller,
                  formKey: _movementFormKey,
                  onSelectDate: () => _selectMovementDate(context),
                  onSubmit: _submitMovement,
                ),
                const SizedBox(height: 24),
              ],

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.positiveBalance,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEdit
                          ? Icons.check_circle_outline
                          : Icons.save_outlined,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit
                          ? 'Atualizar Economia'
                          : 'Salvar Economia',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
