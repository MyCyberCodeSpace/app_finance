import 'package:finance_control/core/model/finance_status_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListStatusWidget extends StatefulWidget {
  final ValueNotifier<int> statusId;

  const ListStatusWidget({super.key, required this.statusId});

  @override
  State<ListStatusWidget> createState() => _ListStatusWidgetState();
}

class _ListStatusWidgetState extends State<ListStatusWidget> {
  late final FinanceStatusBloc financeStatusBloc;
  @override
  void initState() {
    super.initState();
    financeStatusBloc = Modular.get<FinanceStatusBloc>();
    financeStatusBloc.add(LoadFinanceStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceStatusBloc, FinanceStatusBlocState>(
      bloc: financeStatusBloc,
      builder: (context, state) {
        if (state is FinanceStatusLoadingState) {
          return const CircularProgressIndicator();
        }

        if (state is FinanceStatusErrorState) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state is FinanceStatusLoadedState) {
          final statusList = state.listStatus;
          final initialValue =
              statusList.any((e) => e.id == widget.statusId.value)
              ? widget.statusId.value
              : null;
          return DropdownButtonFormField<int>(
            initialValue: initialValue,
            decoration: const InputDecoration(labelText: 'Status'),
            items: statusList.map((FinanceStatusModel t) {
              return DropdownMenuItem<int>(
                value: t.id,
                child: Text(t.label),
              );
            }).toList(),
            onChanged: (v) {
              setState(() => widget.statusId.value = v!);
            },
            validator: (v) =>
                v == null ? 'Selecione um status' : null,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
