import 'package:finance_control/core/model/finance_target_model.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
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
  late final TextEditingController _desiredDepositController;
  late final TextEditingController _recurrencyDaysController;
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
    _desiredDepositController = TextEditingController(
      text: target?.desiredDeposit.toString() ?? '',
    );
    _recurrencyDaysController = TextEditingController(
      text: target?.recurrencyDays.toString() ?? '',
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
    _desiredDepositController.dispose();
    _recurrencyDaysController.dispose();
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
    final desiredDeposit = double.parse(
      _desiredDepositController.text.replaceAll(',', '.'),
    );
    final recurrencyDays = int.parse(_recurrencyDaysController.text);

    final target = FinanceTargetModel(
      id: widget.target?.id,
      label: _labelController.text,
      targetValue: targetValue,
      currentValue: currentValue,
      desiredDeposit: desiredDeposit,
      recurrencyDays: recurrencyDays,
      typeId: widget.target?.typeId ?? 0,
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

  Future<void> _navigateToDepositsHistory() async {
    if (widget.target?.typeId == null) return;

    try {
      final financeTypeRepository = Modular.get<FinanceTypeRepository>();
      final financeType = await financeTypeRepository.getById(widget.target!.typeId);

      final dashboardController = Modular.get<DashboardController>();
      dashboardController.applyFilterByType(financeType);
      
      if (mounted) {
        Modular.to.navigate('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar histórico: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, dynamic>? _calculateProgress() {
    final targetValue = double.tryParse(
      _targetValueController.text.replaceAll(',', '.'),
    );
    final currentValue = double.tryParse(
      _currentValueController.text.replaceAll(',', '.'),
    );
    final desiredDeposit = double.tryParse(
      _desiredDepositController.text.replaceAll(',', '.'),
    );
    final recurrencyDays = int.tryParse(_recurrencyDaysController.text);

    if (targetValue == null || 
        currentValue == null || 
        desiredDeposit == null || 
        recurrencyDays == null ||
        desiredDeposit <= 0 ||
        targetValue <= currentValue) {
      return null;
    }

    final remaining = targetValue - currentValue;
    final depositsNeeded = (remaining / desiredDeposit).ceil();
    final totalDays = depositsNeeded * recurrencyDays;
    final estimatedDate = DateTime.now().add(Duration(days: totalDays));

    final result = {
      'remaining': remaining,
      'depositsNeeded': depositsNeeded,
      'totalDays': totalDays,
      'estimatedDate': estimatedDate,
    };

    if (_dueDate != null) {
      final daysUntilDue = _dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue > 0) {
        final suggestedDepositsCount = (daysUntilDue / recurrencyDays).floor();
        if (suggestedDepositsCount > 0) {
          final suggestedDepositValue = remaining / suggestedDepositsCount;
          result['suggestedDeposit'] = suggestedDepositValue;
          result['suggestedDepositsCount'] = suggestedDepositsCount;
        }
      }
    }

    return result;
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
                          Icons.savings_outlined,
                          size: 20,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Valor Desejado por Depósito',
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
                      controller: _desiredDepositController,
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
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.blue.withValues(alpha: 0.05),
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
                          return 'Informe o valor por depósito';
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
                          Icons.event_repeat_outlined,
                          size: 20,
                          color: AppColors.nevagativeBalance,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recorrência (em dias)',
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
                      controller: _recurrencyDaysController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ex: 7 (semanal), 15 (quinzenal), 30 (mensal)',
                        suffixText: 'dias',
                        suffixStyle: TextStyle(
                          color: AppColors.gray.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: AppColors.nevagativeBalance.withValues(alpha: 0.05),
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
                          return 'Informe a recorrência';
                        }
                        final value = int.tryParse(v);
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

              ValueListenableBuilder(
                valueListenable: _targetValueController,
                builder: (context, _, __) {
                  return ValueListenableBuilder(
                    valueListenable: _currentValueController,
                    builder: (context, _, __) {
                      return ValueListenableBuilder(
                        valueListenable: _desiredDepositController,
                        builder: (context, _, __) {
                          return ValueListenableBuilder(
                            valueListenable: _recurrencyDaysController,
                            builder: (context, _, __) {
                              final calc = _calculateProgress();
                              
                              if (calc == null) return const SizedBox.shrink();

                              final remaining = calc['remaining'] as double;
                              final depositsNeeded = calc['depositsNeeded'] as int;
                              final totalDays = calc['totalDays'] as int;
                              final estimatedDate = calc['estimatedDate'] as DateTime;
                              final suggestedDeposit = calc['suggestedDeposit'] as double?;
                              final suggestedDepositsCount = calc['suggestedDepositsCount'] as int?;

                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.blue.withValues(alpha: 0.1),
                                      AppColors.positiveBalance.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.blue.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calculate_outlined,
                                          color: AppColors.blue,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Projeção da Meta',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.gray.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    _buildInfoRow(
                                      icon: Icons.trending_up,
                                      color: AppColors.orange,
                                      label: 'Falta economizar',
                                      value: 'R\$ ${remaining.toStringAsFixed(2)}',
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      icon: Icons.repeat_rounded,
                                      color: AppColors.nevagativeBalance,
                                      label: 'Depósitos necessários',
                                      value: '$depositsNeeded depósitos',
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      icon: Icons.access_time_rounded,
                                      color: AppColors.blue,
                                      label: 'Tempo estimado',
                                      value: _formatDuration(totalDays),
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      icon: Icons.event_available_rounded,
                                      color: AppColors.positiveBalance,
                                      label: 'Previsão de conclusão',
                                      value: DateFormat('dd/MM/yyyy').format(estimatedDate),
                                    ),

                                    if (suggestedDeposit != null && suggestedDepositsCount != null) ...[
                                      const SizedBox(height: 16),
                                      Divider(color: AppColors.blue.withValues(alpha: 0.3)),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.positiveBalance.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.positiveBalance.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.lightbulb_outline_rounded,
                                              color: AppColors.positiveBalance,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Sugestão para data limite',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.gray.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'R\$ ${suggestedDeposit.toStringAsFixed(2)} por depósito',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.positiveBalance,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Total de $suggestedDepositsCount depósitos',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.gray.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              
              if (isEdit && widget.target?.typeId != null) ...[
                OutlinedButton(
                  onPressed: () {
                    _navigateToDepositsHistory();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    side: BorderSide(color: AppColors.blue, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ver Histórico de Depósitos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(int days) {
    if (days < 30) {
      return '$days ${days == 1 ? 'dia' : 'dias'}';
    } else if (days < 365) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      if (remainingDays == 0) {
        return '$months ${months == 1 ? 'mês' : 'meses'}';
      }
      return '$months ${months == 1 ? 'mês' : 'meses'} e $remainingDays ${remainingDays == 1 ? 'dia' : 'dias'}';
    } else {
      final years = (days / 365).floor();
      final remainingMonths = ((days % 365) / 30).floor();
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'ano' : 'anos'}';
      }
      return '$years ${years == 1 ? 'ano' : 'anos'} e $remainingMonths ${remainingMonths == 1 ? 'mês' : 'meses'}';
    }
  }
}
