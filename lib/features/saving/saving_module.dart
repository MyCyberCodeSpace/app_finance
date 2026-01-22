import 'package:finance_control/features/saving/presentation/pages/finance_saving_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SavingModule extends Module {

  @override
  void routes(r) {
    r.child('/', child: (context) => FinanceSavingPage());
  }
}
