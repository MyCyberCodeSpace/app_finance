import 'package:finance_control/core/model/finance_record_model.dart';
import 'package:finance_control/features/record/presentation/page/record_form_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecordModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/:id',
      child: (context) => RecordFormPage(
        record: Modular.args.data as FinanceRecordModel?,
      ),
      transition: TransitionType.downToUp,
    );
  }
}
