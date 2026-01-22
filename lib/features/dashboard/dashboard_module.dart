import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
import 'package:finance_control/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:finance_control/features/dashboard/presentation/page/filters_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(DashboardController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => DashboardPage());
    r.child(
      '/filters',
      child: (context) => FiltersPage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
