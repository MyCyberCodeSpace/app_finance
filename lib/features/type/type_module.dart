import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:finance_control/features/type/presentation/page/type_form_page.dart';
import 'package:finance_control/features/type/presentation/page/type_list_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TypeModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const FinanceTypeListPage());

    r.child(
      '/form',
      child: (_) => TypeFormPage(
        type: Modular.args.data as FinanceTypeModel?,
      ),
    );
  }
}
