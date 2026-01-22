import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/widgets/popup_select_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TypeFormPage extends StatefulWidget {
  final FinanceTypeModel? type;

  const TypeFormPage({super.key, required this.type});

  @override
  State<TypeFormPage> createState() => _TypeFormPageState();
}

class _TypeFormPageState extends State<TypeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final FinanceTypeBloc financeTypeBloc;
  late final TextEditingController _limitValueTEC;
  late FinanceCategory _financeCategory;
  bool _isActive = true;
  bool _hasLimit = false;

  @override
  void initState() {
    super.initState();
    final type = widget.type;
    _nameController = TextEditingController(text: type?.name ?? '');
    _financeCategory = type?.financeCategory ?? FinanceCategory.expense;
    _isActive = type?.isActive ?? true;
    _hasLimit = type?.hasLimit ?? false;
    _limitValueTEC = TextEditingController(
      text: type?.limitValue != null
          ? type!.limitValue.toString()
          : '',
    );

    financeTypeBloc = Modular.get<FinanceTypeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.type != null;
    return Scaffold(
      backgroundColor: AppColors.gray.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Editar Tipo' : 'Novo Tipo',
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
                        isEdit ? Icons.edit_rounded : Icons.category_rounded,
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
                            isEdit ? 'Atualizar Tipo' : 'Criar Novo Tipo',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEdit
                                ? 'Atualize os dados do tipo financeiro'
                                : 'Crie uma nova categoria de transação',
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
                          'Nome do Tipo',
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Alimentação, Salário, Investimentos...',
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
                              ? 'Informe o nome'
                              : null,
                    ),

                    const SizedBox(height: 24),

                    PopupSelectField<FinanceCategory>(
                      label: 'Categoria',
                      labelIcon: Icons.category_outlined,
                      selectedValue: _financeCategory,
                      options: FinanceCategory.values.map((category) {
                        final isIncome = category == FinanceCategory.income;
                        final isExpense = category == FinanceCategory.expense;
                        final categoryColor = isIncome
                            ? AppColors.positiveBalance
                            : isExpense
                                ? AppColors.nevagativeBalance
                                : AppColors.orange;
                        final categoryIcon = isIncome
                            ? Icons.trending_up_rounded
                            : isExpense
                                ? Icons.trending_down_rounded
                                : Icons.show_chart_rounded;

                        return PopupSelectOption<FinanceCategory>(
                          value: category,
                          label: category.label,
                          icon: categoryIcon,
                          color: categoryColor,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _financeCategory = value);
                      },
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isActive
                            ? AppColors.positiveBalance.withValues(alpha: 0.05)
                            : AppColors.gray.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isActive
                              ? AppColors.positiveBalance.withValues(alpha: 0.3)
                              : AppColors.gray.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isActive ? Icons.check_circle : Icons.cancel,
                            color: _isActive
                                ? AppColors.positiveBalance
                                : AppColors.gray.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray.shade600,
                                  ),
                                ),
                                Text(
                                  _isActive ? 'Ativo' : 'Inativo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _isActive
                                        ? AppColors.positiveBalance
                                        : AppColors.gray.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isActive,
                            onChanged: (value) {
                              setState(() => _isActive = value);
                            },
                            activeThumbColor: AppColors.positiveBalance,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _hasLimit
                            ? AppColors.orange.withValues(alpha: 0.05)
                            : AppColors.gray.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _hasLimit
                              ? AppColors.orange.withValues(alpha: 0.3)
                              : AppColors.gray.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: _hasLimit
                                ? AppColors.orange
                                : AppColors.gray.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Limite de Gastos',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray.shade600,
                                  ),
                                ),
                                Text(
                                  _hasLimit ? 'Habilitado' : 'Desabilitado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _hasLimit
                                        ? AppColors.orange
                                        : AppColors.gray.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _hasLimit,
                            onChanged: (value) {
                              setState(() => _hasLimit = value);
                            },
                            activeThumbColor: AppColors.orange,
                          ),
                        ],
                      ),
                    ),

                    if (_hasLimit) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 20,
                            color: AppColors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Valor do Limite',
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
                        controller: _limitValueTEC,
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
                          final value = double.tryParse(v.replaceAll(',', '.'));
                          if (value == null || value <= 0) {
                            return 'Informe um valor válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final model = FinanceTypeModel(
                      id: widget.type?.id,
                      name: _nameController.text,
                      financeCategory: _financeCategory,
                      isActive: _isActive,
                      hasLimit: _hasLimit,
                      limitValue: _hasLimit && _limitValueTEC.text.isNotEmpty
                          ? double.parse(_limitValueTEC.text.replaceAll(',', '.'))
                          : 0.0,
                    );

                    if (isEdit) {
                      financeTypeBloc.add(UpdateFinanceTypeEvent(model));
                    } else {
                      financeTypeBloc.add(CreateFinanceTypeEvent(model));
                    }

                    Modular.to.pop();
                  }
                },
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
                      isEdit ? 'Atualizar Tipo' : 'Salvar Tipo',
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
