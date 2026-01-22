import 'package:finance_control/core/model/finance_savings_model.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  late final TextEditingController _labelController;
  late final TextEditingController _valueController;
  late final FinanceSavingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Modular.get<FinanceSavingsBloc>();
    _labelController = TextEditingController(
      text: widget.saving?.label ?? '',
    );
    _valueController = TextEditingController(
      text: widget.saving != null
          ? widget.saving!.value.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final value = double.tryParse(
        _valueController.text.replaceAll(',', '.'),
      );
      if (value != null) {
        final savings = FinanceSavingsModel(
          id: widget.saving?.id,
          label: _labelController.text,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.positiveBalance,
                      AppColors.positiveBalance.withValues(
                        alpha: 0.8,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.positiveBalance.withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEdit
                            ? Icons.edit_rounded
                            : Icons.savings_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? 'Atualizar Economia'
                                : 'Criar Nova Economia',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEdit
                                ? 'Atualize os dados da sua economia'
                                : 'Registre suas reservas financeiras',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
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
                      controller: _labelController,
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
                      controller: _valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: 'R\$ ',
                        prefixStyle: TextStyle(
                          color: AppColors.positiveBalance,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Informe o valor';
                        }
                        final value = double.tryParse(
                          v.replaceAll(',', '.'),
                        );
                        if (value == null || value <= 0) {
                          return 'Informe um valor válido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
            ],
          ),
        ),
      ),
    );
  }
}
