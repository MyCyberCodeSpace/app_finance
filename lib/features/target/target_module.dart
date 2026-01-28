import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:finance_control/features/target/presentation/page/financial_target_page.dart';
import 'package:finance_control/features/target/presentation/page/target_form_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TargetModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const FinanceTargetListPage());
    
    r.child(
      '/form',
      child: (_) => TargetFormPage(
        target: r.args.data as FinanceTargetModel?,
      ),
    );
  }
}
