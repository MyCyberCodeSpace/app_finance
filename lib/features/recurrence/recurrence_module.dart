import 'package:finance_control/features/recurrence/presentation/pages/finance_recurrence_form_page.dart';
import 'package:finance_control/features/recurrence/presentation/pages/finance_recurrence_history_page.dart';
import 'package:finance_control/features/recurrence/presentation/pages/finance_recurrence_page.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecurrenceModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const FinanceRecurrencePage());
    r.child('/form', child: (_) => const FinanceRecurrenceFormPage());
    r.child(
      '/history',
      child: (_) => FinanceRecurrenceHistoryPage(
        recurrence: Modular.args.data as FinanceRecurrenceModel,
      ),
    );
  }
}
