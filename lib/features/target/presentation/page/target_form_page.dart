import 'package:finance_control/core/model/finance_target_model.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class TargetFormPage extends StatefulWidget {
  final FinanceTargetModel? target;

  const TargetFormPage({super.key, this.target});

  @override
  State<TargetFormPage> createState() => _TargetFormPageState();
}

class _TargetFormPageState extends State<TargetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _targetValueController;
  late final TextEditingController _currentValueController;
  late final TextEditingController _dueDateController;
  late final FinanceTargetBloc financeTargetBloc;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    financeTargetBloc = Modular.get<FinanceTargetBloc>();
    
    final target = widget.target;
    _labelController = TextEditingController(text: target?.label ?? '');
    _targetValueController = TextEditingController(
      text: target?.targetValue.toString() ?? '',
    );
    _currentValueController = TextEditingController(
      text: target?.currentValue.toString() ?? '',
    );
    _dueDate = target?.dueDate;
    _dueDateController = TextEditingController(
      text: _dueDate != null 
        ? DateFormat('dd/MM/yyyy').format(_dueDate!) 
        : '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final targetValue = double.parse(
      _targetValueController.text.replaceAll(',', '.'),
    );
    final currentValue = double.parse(
      _currentValueController.text.replaceAll(',', '.'),
    );

    final target = FinanceTargetModel(
      id: widget.target?.id,
      label: _labelController.text,
      targetValue: targetValue,
      currentValue: currentValue,
      dueDate: _dueDate,
      createdAt: widget.target?.createdAt,
      updatedAt: widget.target != null ? DateTime.now() : null,
    );

    if (widget.target == null) {
      financeTargetBloc.add(CreateFinanceTargetEvent(target));
    } else {
      financeTargetBloc.add(UpdateFinanceTargetEvent(target));
    }

    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.target != null;

    return Scaffold(
      backgroundColor: AppColors.gray.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Editar Meta' : 'Nova Meta',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                      AppColors.positiveBalance.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.positiveBalance.withValues(alpha: 0.3),
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
                        isEdit ? Icons.edit_rounded : Icons.add_task_rounded,
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
                            isEdit ? 'Atualizar Meta' : 'Criar Nova Meta',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEdit
                                ? 'Atualize os dados da sua meta'
                                : 'Defina seus objetivos financeiros',
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
                      color: AppColors.gray.shade300.withValues(alpha: 0.5),
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
                        hintText: 'Ex: Viagem de férias, Comprar carro...',
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
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Informe a descrição'
                              : null,
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.flag_circle_outlined,
                          size: 20,
                          color: AppColors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Valor da Meta',
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
                      controller: _targetValueController,
                      keyboardType: const TextInputType.numberWithOptions(
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
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.orange.withValues(alpha: 0.05),
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
                        final value = double.tryParse(v);
                        if (value == null || value <= 0) {
                          return 'Informe um valor válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20,
                          color: AppColors.positiveBalance,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Valor Atual',
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
                      controller: _currentValueController,
                      keyboardType: const TextInputType.numberWithOptions(
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
                        fillColor: AppColors.positiveBalance.withValues(alpha: 0.05),
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
                          return 'Informe o valor atual';
                        }
                        final value = double.tryParse(v);
                        if (value == null || value < 0) {
                          return 'Informe um valor válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 20,
                          color: AppColors.gray.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Data Limite (Opcional)',
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
                      controller: _dueDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Selecione uma data',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: AppColors.gray.shade600,
                          size: 20,
                        ),
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
                      onTap: () => _selectDate(context),
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
                      isEdit ? Icons.check_circle_outline : Icons.save_outlined,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit ? 'Atualizar Meta' : 'Salvar Meta',
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
