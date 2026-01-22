import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_event.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListTypeWidget extends StatefulWidget {
  final int? selectedTypeId;
  final ValueChanged<int?> onChanged;

  const ListTypeWidget({
    super.key,
    required this.selectedTypeId,
    required this.onChanged,
  });

  @override
  State<ListTypeWidget> createState() => _ListTypeWidgetState();
}

class _ListTypeWidgetState extends State<ListTypeWidget> {
  late final FinanceTypeBloc financeTypeBloc;

  @override
  void initState() {
    super.initState();
    financeTypeBloc = Modular.get<FinanceTypeBloc>();
    financeTypeBloc.add(LoadFinanceTypesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceTypeBloc, FinanceTypeBlocState>(
      bloc: financeTypeBloc,
      builder: (context, state) {
        if (state is FinanceTypeLoadingState) {
          return const CircularProgressIndicator();
        }

        if (state is FinanceTypeErrorState) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state is FinanceTypeLoadedState) {
          return DropdownButtonFormField<int>(
            initialValue: widget.selectedTypeId,
            decoration: const InputDecoration(labelText: 'Tipo'),
            items: state.types.map((t) {
              return DropdownMenuItem<int>(
                value: t.id,
                child: Text(t.name),
              );
            }).toList(),
            onChanged: widget.onChanged,
            validator: (v) => v == null ? 'Selecione um tipo' : null,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
