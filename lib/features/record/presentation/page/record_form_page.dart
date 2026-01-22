import 'package:finance_control/core/model/finance_record_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_state.dart';
import 'package:finance_control/core/presentation/widgets/popup_select_field.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/record/presentation/widget/list_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class RecordFormPage extends StatefulWidget {
  final FinanceRecordModel? record;

  const RecordFormPage({super.key, this.record});

  @override
  State<RecordFormPage> createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  late int? _dueDay;
  int? _typeId;
  late bool _isRecurring;
  late final FinanceRecordBloc financeRecordBloc;
  late final FinanceTypeBloc financeTypeBloc;
  late final FinancePaymentBloc financePaymentBloc;
  late final TextEditingController _selectedDateTEC;
  late final TextEditingController _dueDayTEC;
  late final TextEditingController _valueTEC;
  late final TextEditingController _descriptionTEC;
  late final TextEditingController _totalInstallmentsTEC;
  late final ValueNotifier<int> statusId;
  late final ValueNotifier<int> paymentId;

  @override
  void initState() {
    super.initState();
    statusId = ValueNotifier(0);
    paymentId = ValueNotifier(0);

    financeRecordBloc = Modular.get<FinanceRecordBloc>();
    financeTypeBloc = Modular.get<FinanceTypeBloc>();
    financeTypeBloc.add(LoadFinanceTypesEvent());
    financePaymentBloc = Modular.get<FinancePaymentBloc>();
    financePaymentBloc.add(LoadFinancePaymentEvent());

    final r = widget.record;

    _date = r?.date ?? DateTime.now();

    _selectedDateTEC = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_date),
    );

    _dueDay = r?.dueDay;

    _dueDayTEC = TextEditingController(
      text: _dueDay != null ? _dueDay.toString() : '',
    );

    _valueTEC = TextEditingController(
      text: r?.value != null ? r!.value.toString() : '',
    );

    _descriptionTEC = TextEditingController(
      text: r?.description ?? '',
    );

    statusId.value = widget.record?.statusId ?? 1;

    _typeId = r?.typeId;
    paymentId.value = r?.paymentId ?? 1;
    _isRecurring = r?.isRecurring ?? false;
    _totalInstallmentsTEC = TextEditingController(
      text: r?.totalInstallments?.toString() ?? '',
    );
  }

  void _submit() {
    if (_typeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um tipo')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final value = double.parse(_valueTEC.text.replaceAll(',', '.'));

    final record = FinanceRecordModel(
      id: widget.record?.id,
      date: _date,
      value: value,
      typeId: _typeId!,
      paymentId: paymentId.value,
      description: _descriptionTEC.text.isEmpty
          ? null
          : _descriptionTEC.text,
      isRecurring: _isRecurring,
      dueDay: _isRecurring ? _dueDay : null,
      totalInstallments: _isRecurring
          ? int.tryParse(_totalInstallmentsTEC.text)
          : null,

      statusId: _isRecurring ? statusId.value : null,
      createdAt: widget.record?.createdAt,
      updatedAt: widget.record != null ? DateTime.now() : null,
    );
    if (widget.record == null) {
      financeRecordBloc.add(CreateFinanceRecordEvent(record));
    } else {
      financeRecordBloc.add(UpdateFinanceRecordEvent(record));
    }

    Modular.to.pop();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              onSurface: AppColors.gray.shade800,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blue,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.record != null;

    return Scaffold(
      backgroundColor: AppColors.gray.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? 'Editar Registro' : 'Novo Registro',
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
                            : Icons.receipt_long_rounded,
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
                                ? 'Atualizar Registro'
                                : 'Criar Novo Registro',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEdit
                                ? 'Atualize os dados do registro'
                                : 'Registre uma nova transação financeira',
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
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Valor e Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _valueTEC,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.gray.shade800,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Valor',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray.shade600,
                              ),
                              filled: true,
                              fillColor: AppColors.gray.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.gray.shade200,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.gray.shade200,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.blue,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.nevagativeBalance,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.nevagativeBalance,
                                  width: 2,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                              prefixIcon: Icon(
                                Icons.paid_rounded,
                                color: AppColors.positiveBalance,
                                size: 20,
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
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _selectedDateTEC,
                            readOnly: true,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.gray.shade800,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Data',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray.shade600,
                              ),
                              filled: true,
                              fillColor: AppColors.gray.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.gray.shade200,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.gray.shade200,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                              suffixIcon: Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.blue,
                                size: 18,
                              ),
                            ),
                            onTap: () => _selectDate(
                              context,
                              _selectedDateTEC,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gray.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.positiveBalance
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.category_rounded,
                            color: AppColors.positiveBalance,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Tipo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<FinanceTypeBloc, FinanceTypeBlocState>(
                      bloc: financeTypeBloc,
                      builder: (context, state) {
                        if (state is FinanceTypeLoadingState) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is FinanceTypeErrorState) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: AppColors.nevagativeBalance,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }

                        if (state is FinanceTypeLoadedState) {
                          if (state.types.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Nenhum tipo cadastrado',
                                style: TextStyle(
                                  color: AppColors.gray.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }

                          if (_typeId != null && !state.types.any((t) => t.id == _typeId)) {
                            _typeId = state.types.first.id;
                          }

                          return PopupSelectField<int>(
                            selectedValue: _typeId ?? state.types.first.id!,
                            options: state.types.map((type) {
                              final isIncome = type.financeCategory.name == 'income';
                              final isExpense = type.financeCategory.name == 'expense';
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

                              return PopupSelectOption<int>(
                                value: type.id!,
                                label: type.name,
                                icon: categoryIcon,
                                color: categoryColor,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _typeId = value);
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gray.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notes_rounded,
                            color: AppColors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionTEC,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.gray.shade800,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Adicione uma descrição (opcional)',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray.shade400,
                        ),
                        filled: true,
                        fillColor: AppColors.gray.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.gray.shade200,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.gray.shade200,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.blue,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gray.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.credit_card_rounded,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Forma de Pagamento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<FinancePaymentBloc, FinancePaymentBlocState>(
                      bloc: financePaymentBloc,
                      builder: (context, state) {
                        if (state is FinancePaymentLoadingState) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is FinancePaymentErrorState) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: AppColors.nevagativeBalance,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }

                        if (state is FinancePaymentLoadedState) {
                          if (state.listPayment.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Nenhuma forma de pagamento cadastrada',
                                style: TextStyle(
                                  color: AppColors.gray.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }

                          if (paymentId.value == 0 || !state.listPayment.any((p) => p.id == paymentId.value)) {
                            paymentId.value = state.listPayment.first.id!;
                          }

                          return PopupSelectField<int>(
                            selectedValue: paymentId.value,
                            options: state.listPayment.map((payment) {
                              IconData icon;
                              Color color;

                              switch (payment.paymentName.toLowerCase()) {
                                case 'dinheiro':
                                  icon = Icons.money_rounded;
                                  color = AppColors.positiveBalance;
                                  break;
                                case 'cartão de crédito':
                                case 'credito':
                                case 'crédito':
                                  icon = Icons.credit_card_rounded;
                                  color = AppColors.orange;
                                  break;
                                case 'cartão de débito':
                                case 'debito':
                                case 'débito':
                                  icon = Icons.credit_card_outlined;
                                  color = AppColors.blue;
                                  break;
                                case 'pix':
                                  icon = Icons.pix_rounded;
                                  color = AppColors.positiveBalance;
                                  break;
                                case 'transferência':
                                case 'transferencia':
                                  icon = Icons.compare_arrows_rounded;
                                  color = AppColors.blue;
                                  break;
                                default:
                                  icon = Icons.payment_rounded;
                                  color = AppColors.gray.shade700;
                              }

                              return PopupSelectOption<int>(
                                value: payment.id!,
                                label: payment.paymentName,
                                icon: icon,
                                color: color,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => paymentId.value = value);
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gray.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _isRecurring,
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.nevagativeBalance
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.repeat_rounded,
                              color: AppColors.nevagativeBalance,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Despesa Recorrente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gray.shade800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Ex: cartão de crédito, parcelas',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.gray.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      activeThumbColor: AppColors.positiveBalance,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      onChanged: (v) {
                        setState(() {
                          _isRecurring = v;
                          if (!v) {
                            _dueDayTEC.clear();
                            _totalInstallmentsTEC.clear();
                          }
                        });
                      },
                    ),
                    if (_isRecurring) ...[
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.gray.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _dueDayTEC,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.gray.shade800,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Dia de vencimento',
                                hintText: 'Ex: 10',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray.shade600,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray.shade400,
                                ),
                                filled: true,
                                fillColor: AppColors.gray.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.gray.shade200,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.gray.shade200,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.blue,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.nevagativeBalance,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors
                                            .nevagativeBalance,
                                        width: 2,
                                      ),
                                    ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                prefixIcon: Icon(
                                  Icons.event_rounded,
                                  color: AppColors.orange,
                                  size: 20,
                                ),
                              ),
                              validator: (v) {
                                if (_isRecurring) {
                                  final day = int.tryParse(v ?? '');
                                  if (day == null ||
                                      day < 1 ||
                                      day > 31) {
                                    return 'Informe um dia entre 1 e 31';
                                  }
                                }
                                return null;
                              },
                              onChanged: (v) =>
                                  _dueDay = int.tryParse(v),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _totalInstallmentsTEC,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.gray.shade800,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Total de parcelas',
                                hintText: 'Ex: 12',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray.shade600,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray.shade400,
                                ),
                                filled: true,
                                fillColor: AppColors.gray.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.gray.shade200,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.gray.shade200,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.blue,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  borderSide: BorderSide(
                                    color:
                                        AppColors.nevagativeBalance,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors
                                            .nevagativeBalance,
                                        width: 2,
                                      ),
                                    ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                prefixIcon: Icon(
                                  Icons.format_list_numbered_rounded,
                                  color: AppColors.blue,
                                  size: 20,
                                ),
                              ),
                              validator: (v) {
                                if (_isRecurring) {
                                  final total = int.tryParse(v ?? '');
                                  if (total == null || total <= 0) {
                                    return 'Informe um número válido';
                                  }
                                }
                                return null;
                              },
                            ),
                            if (widget.record != null) ...[
                              const SizedBox(height: 16),
                              ListStatusWidget(statusId: statusId),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),

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
                          ? 'Atualizar Registro'
                          : 'Salvar Registro',
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
