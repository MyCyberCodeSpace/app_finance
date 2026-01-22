import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_control/core/model/finance_payment_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc_state.dart';

class ListPaymentWidget extends StatefulWidget {
  final ValueNotifier<int> paymentId;

  const ListPaymentWidget({
    super.key,
    required this.paymentId,
  });

  @override
  State<ListPaymentWidget> createState() => _ListPaymentWidgetState();
}

class _ListPaymentWidgetState extends State<ListPaymentWidget> {
  late final FinancePaymentBloc financePaymentBloc;

  @override
  void initState() {
    super.initState();
    financePaymentBloc = Modular.get<FinancePaymentBloc>();
    financePaymentBloc.add(LoadFinancePaymentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancePaymentBloc, FinancePaymentBlocState>(
      bloc: financePaymentBloc,
      builder: (context, state) {
        if (state is FinancePaymentLoadingState) {
          return const CircularProgressIndicator();
        }

        if (state is FinancePaymentErrorState) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state is FinancePaymentLoadedState) {
          final paymentList = state.listPayment;

          final initialValue = paymentList.any(
            (e) => e.id == widget.paymentId.value,
          )
              ? widget.paymentId.value
              : null;

          return DropdownButtonFormField<int>(
            initialValue: initialValue,
            decoration: const InputDecoration(
              labelText: 'Forma de pagamento',
            ),
            items: paymentList.map((FinancePaymentModel p) {
              return DropdownMenuItem<int>(
                value: p.id,
                child: Text(p.paymentName),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => widget.paymentId.value = v);
              }
            },
            validator: (v) =>
                v == null ? 'Selecione uma forma de pagamento' : null,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
