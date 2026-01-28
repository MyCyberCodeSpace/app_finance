import 'package:finance_control/core/model/finance_record_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_event.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:finance_control/features/record/presentation/widget/record_description_card.dart';
import 'package:finance_control/features/record/presentation/widget/record_header_card.dart';
import 'package:finance_control/features/record/presentation/widget/record_payment_card.dart';
import 'package:finance_control/features/record/presentation/widget/record_type_card.dart';
import 'package:finance_control/features/record/presentation/widget/record_value_date_card.dart';
import 'package:flutter/material.dart';
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
  int? _typeId;
  late final FinanceRecordBloc financeRecordBloc;
  late final FinanceTypeBloc financeTypeBloc;
  late final FinancePaymentBloc financePaymentBloc;
  late final TextEditingController _selectedDateTEC;
  late final TextEditingController _valueTEC;
  late final TextEditingController _descriptionTEC;
  late final ValueNotifier<int> paymentId;

  @override
  void initState() {
    super.initState();
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

    _valueTEC = TextEditingController(
      text: r?.value != null ? r!.value.toString() : '',
    );

    _descriptionTEC = TextEditingController(
      text: r?.description ?? '',
    );
  
    _typeId = r?.typeId;
    
    // Set initial payment ID from record or will be set when payments load
    if (r?.paymentId != null) {
      paymentId.value = r!.paymentId;
    }

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
              RecordHeaderCard(isEdit: isEdit),
              const SizedBox(height: 24),
              RecordValueDateCard(
                valueController: _valueTEC,
                dateController: _selectedDateTEC,
                selectedDate: _date,
                onDateChanged: (date) => setState(() => _date = date),
              ),
              const SizedBox(height: 16),
              RecordTypeCard(
                financeTypeBloc: financeTypeBloc,
                selectedTypeId: _typeId,
                onTypeChanged: (typeId) => setState(() => _typeId = typeId),
              ),
              const SizedBox(height: 16),
              RecordDescriptionCard(descriptionController: _descriptionTEC),
              const SizedBox(height: 16),
              RecordPaymentCard(
                financePaymentBloc: financePaymentBloc,
                paymentId: paymentId,
                onPaymentChanged: (id) => setState(() => paymentId.value = id),
              ),
              const SizedBox(height: 16),
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
                      isEdit ? Icons.check_circle_outline : Icons.save_outlined,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEdit ? 'Atualizar Registro' : 'Salvar Registro',
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
