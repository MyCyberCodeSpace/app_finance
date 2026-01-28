import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/features/recurrence/domain/enums/recurrence_type.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';
import 'package:finance_control/core/model/finance_payment_model.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_movement_model.dart';
import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/recurrence/domain/repository/finance_recurrence_movement_repository.dart';
import 'package:finance_control/features/recurrence/presentation/bloc/finance_recurrence_bloc.dart';
import 'package:finance_control/features/recurrence/presentation/bloc/finance_recurrence_bloc_event.dart';
import 'package:finance_control/features/recurrence/presentation/widgets/finance_recurrence_movement_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class FinanceRecurrenceFormPage extends StatefulWidget {
  final FinanceRecurrenceModel? recurrence;
  final List<FinancePaymentModel>? paymentMethods;

  const FinanceRecurrenceFormPage({
    super.key,
    this.recurrence,
    this.paymentMethods,
  });

  @override
  State<FinanceRecurrenceFormPage> createState() =>
      _FinanceRecurrenceFormPageState();
}

class _FinanceRecurrenceFormPageState extends State<FinanceRecurrenceFormPage> {
  late final FinanceRecurrenceBloc financeRecurrenceBloc;
  late final FinanceRecurrenceMovementRepository movementRepository;
  late TextEditingController labelController;
  late TextEditingController valueController;
  late TextEditingController descriptionController;
  late TextEditingController movementValueController;
  late TextEditingController movementDescriptionController;
  late TextEditingController movementDateController;
  late GlobalKey<FormState> movementFormKey;
  
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? selectedMovementDate;
  RecurrenceType? selectedRecurrenceType;
  FinanceCategory? selectedCategory;
  int? selectedPaymentId;
  int? selectedDueDay;

  @override
  void initState() {
    super.initState();
    financeRecurrenceBloc = Modular.get<FinanceRecurrenceBloc>();
    movementRepository = Modular.get<FinanceRecurrenceMovementRepository>();
    
    labelController = TextEditingController(text: widget.recurrence?.label ?? '');
    valueController = TextEditingController(
      text: widget.recurrence?.value.toStringAsFixed(2) ?? '',
    );
    descriptionController =
        TextEditingController(text: widget.recurrence?.description ?? '');
    movementValueController = TextEditingController();
    movementDescriptionController = TextEditingController();
    movementDateController = TextEditingController();
    movementFormKey = GlobalKey<FormState>();
    
    selectedStartDate = widget.recurrence?.startDate;
    selectedEndDate = widget.recurrence?.endDate;
    selectedRecurrenceType = widget.recurrence?.recurrenceType;
    selectedCategory = widget.recurrence?.financeCategory;
    selectedPaymentId = widget.recurrence?.paymentId;
    selectedDueDay = widget.recurrence?.dueDay;
  }

  @override
  void dispose() {
    labelController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    movementValueController.dispose();
    movementDescriptionController.dispose();
    movementDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => selectedStartDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => selectedEndDate = picked);
    }
  }

  Future<void> _selectMovementDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMovementDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedMovementDate = picked;
        movementDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  bool _validateForm() {
    if (labelController.text.isEmpty) {
      _showErrorSnackBar('Por favor, preencha o nome da recorrência');
      return false;
    }
    if (valueController.text.isEmpty || double.tryParse(valueController.text) == null) {
      _showErrorSnackBar('Por favor, preencha um valor válido');
      return false;
    }
    if (selectedStartDate == null) {
      _showErrorSnackBar('Por favor, selecione uma data de início');
      return false;
    }
    if (selectedRecurrenceType == null) {
      _showErrorSnackBar('Por favor, selecione o tipo de recorrência');
      return false;
    }
    if (selectedCategory == null) {
      _showErrorSnackBar('Por favor, selecione a categoria');
      return false;
    }
    if (selectedPaymentId == null) {
      _showErrorSnackBar('Por favor, selecione um método de pagamento');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _saveRecurrence() {
    if (!_validateForm()) return;

    final newRecurrence = FinanceRecurrenceModel(
      id: widget.recurrence?.id,
      label: labelController.text,
      value: double.parse(valueController.text),
      paymentId: selectedPaymentId!,
      recurrenceType: selectedRecurrenceType!,
      dueDay: selectedDueDay,
      startDate: selectedStartDate!,
      endDate: selectedEndDate,
      description: descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
      isActive: widget.recurrence?.isActive ?? true,
      financeCategory: selectedCategory!,
      createdAt: widget.recurrence?.createdAt,
      updatedAt: DateTime.now(),
    );

    if (widget.recurrence == null) {
      financeRecurrenceBloc.add(CreateFinanceRecurrenceEvent(newRecurrence));
    } else {
      financeRecurrenceBloc.add(UpdateFinanceRecurrenceEvent(newRecurrence));
    }

    Navigator.pop(context);
  }

  void _submitMovement() async {
    if (widget.recurrence == null) {
      _showErrorSnackBar('Salve a recorrência antes de adicionar movimentos');
      return;
    }

    if (movementFormKey.currentState!.validate() && selectedMovementDate != null) {
      try {
        final value = double.parse(movementValueController.text);
        
        final movement = FinanceRecurrenceMovementModel(
          recurrenceId: widget.recurrence!.id!,
          value: value,
          description: movementDescriptionController.text.isEmpty
              ? null
              : movementDescriptionController.text,
          executionDate: selectedMovementDate!,
        );

        await movementRepository.create(movement);

        if (mounted) {
          movementValueController.clear();
          movementDescriptionController.clear();
          movementDateController.clear();
          setState(() => selectedMovementDate = null);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Movimento registrado com sucesso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao registrar movimento: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else if (selectedMovementDate == null) {
      _showErrorSnackBar('Selecione uma data de execução');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: -1,
      text: widget.recurrence == null ? 'Nova Recorrência' : 'Editar Recorrência',
      onPressedFloatingActionButton: () {},
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Nome da Recorrência',
              controller: labelController,
              hint: 'Ex: Salário, Aluguel, Internet',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Valor (R\$)',
              controller: valueController,
              hint: '0.00',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildPaymentMethodDropdown(),
            const SizedBox(height: 16),
            _buildRecurrenceTypeDropdown(),
            const SizedBox(height: 16),
            _buildDueDayInput(),
            const SizedBox(height: 16),
            _buildDatePicker(
              label: 'Data de Início',
              date: selectedStartDate,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: 16),
            _buildDatePicker(
              label: 'Data de Término (opcional)',
              date: selectedEndDate,
              onTap: () => _selectEndDate(context),
              optional: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Descrição (opcional)',
              controller: descriptionController,
              hint: 'Adicione uma descrição...',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            if (widget.recurrence != null) ...[
              FinanceRecurrenceMovementFormWidget(
                valueController: movementValueController,
                descriptionController: movementDescriptionController,
                executionDateController: movementDateController,
                formKey: movementFormKey,
                onSelectDate: () => _selectMovementDate(context),
                onSubmit: _submitMovement,
                selectedDate: selectedMovementDate,
              ),
              const SizedBox(height: 24),
            ],
            _buildActionButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
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
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<FinanceCategory>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: selectedCategory,
            hint: const Text('Selecione uma categoria'),
            items: FinanceCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.label),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedCategory = value),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pagamento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: selectedPaymentId,
            hint: const Text('Selecione um método'),
            items: widget.paymentMethods?.map((payment) {
                  return DropdownMenuItem(
                    value: payment.id,
                    child: Text(payment.paymentName),
                  );
                }).toList() ??
                [],
            onChanged: (value) => setState(() => selectedPaymentId = value),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurrenceTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Recorrência',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<RecurrenceType>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: selectedRecurrenceType,
            hint: const Text('Selecione uma recorrência'),
            items: RecurrenceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.label),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedRecurrenceType = value),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDayInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dia do Vencimento (opcional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '1 - 31',
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
          onChanged: (value) {
            final day = int.tryParse(value);
            if (day != null && day >= 1 && day <= 31) {
              setState(() => selectedDueDay = day);
            }
          },
          controller: TextEditingController(
            text: selectedDueDay?.toString() ?? '',
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray.shade800,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    date != null
                        ? DateFormat('dd/MM/yyyy').format(date)
                        : optional
                            ? 'Sem data de término'
                            : 'Selecione uma data',
                    style: TextStyle(
                      color: date != null
                          ? AppColors.gray.shade800
                          : AppColors.gray.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (date != null && optional)
                  GestureDetector(
                    onTap: () => setState(() => selectedEndDate = null),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.gray.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gray.shade300,
              foregroundColor: AppColors.gray.shade800,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _saveRecurrence,
            child: Text(widget.recurrence == null ? 'Criar' : 'Salvar'),
          ),
        ),
      ],
    );
  }
}
