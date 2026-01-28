import 'package:finance_control/features/target/domain/model/finance_target_model.dart';
import 'package:finance_control/features/target/presentation/page/financial_target_page.dart';
import 'package:finance_control/features/target/presentation/page/finance_target_form_page.dart';
import 'package:finance_control/features/target/presentation/page/finance_target_history_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TargetModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const FinanceTargetListPage());
    
    r.child(
      '/form',
      child: (_) => FinanceTargetFormPage(
        target: r.args.data as FinanceTargetModel?,
      ),
    );

    r.child(
      '/history',
      child: (_) => FinanceTargetHistoryPage(
        target: r.args.data as FinanceTargetModel,
      ),
    );
  }
}
