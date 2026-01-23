import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/data/datasource/preferences/user_preferences_datasource.dart';
import 'package:finance_control/core/data/repositories/finance_payment_repository_impl.dart';
import 'package:finance_control/core/data/repositories/finance_record_repository_impl.dart';
import 'package:finance_control/core/data/repositories/finance_savings_repository_impl.dart';
import 'package:finance_control/core/data/repositories/finance_status_repository_impl.dart';
import 'package:finance_control/core/data/repositories/finance_target_repository_impl.dart';
import 'package:finance_control/core/data/repositories/finance_type_repository_impl.dart';
import 'package:finance_control/core/domain/repositories/finance_payment_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_record_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_savings_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_status_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_target_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/presentation/bloc/finance_payment/finance_payment_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_status/finance_status_bloc.dart';
import 'package:finance_control/core/presentation/bloc/finance_type/finance_type_bloc.dart';
import 'package:finance_control/core/presentation/controllers/finance_record_controller.dart';
import 'package:finance_control/core/presentation/controllers/finance_shared_preferences_controller.dart';
import 'package:finance_control/core/presentation/controllers/finance_type_controller.dart';
import 'package:finance_control/features/dashboard/controller/dashboard_controller.dart';
import 'package:finance_control/features/dashboard/dashboard_module.dart';
import 'package:finance_control/features/record/record_module.dart';
import 'package:finance_control/features/saving/presentation/bloc/finance_savings_bloc.dart';
import 'package:finance_control/features/saving/saving_module.dart';
import 'package:finance_control/features/target/presentation/bloc/finance_target_bloc.dart';
import 'package:finance_control/features/target/target_module.dart';
import 'package:finance_control/features/type/type_module.dart';
import 'package:finance_control/features/about/presentation/page/about_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
    i.addLazySingleton(InitialDatabase.new);
    i.addLazySingleton(UserPreferencesDatasource.new);
    i.addLazySingleton(FinanceSharedPreferencesController.new);
    i.addLazySingleton<FinanceTypeRepository>(
      () => FinanceTypeRepositoryImpl(i()),
    );
    i.addLazySingleton<FinanceRecordRepository>(
      () => FinanceRecordRepositoryImpl(i(), i()),
    );
    i.addLazySingleton<FinanceStatusRepository>(
      () => FinanceStatusRepositoryImpl(i()),
    );
    i.addLazySingleton<FinancePaymentRepository>(
      () => FinancePaymentRepositoryImpl(i()),
    );
    i.addLazySingleton<FinanceSavingsRepository>(
      () => FinanceSavingsRepositoryImpl(i()),
    );
    i.addLazySingleton<FinanceTargetRepository>(
      () => FinanceTargetRepositoryImpl(i()),
    );
    i.addLazySingleton(FinanceSavingsBloc.new);
    i.addLazySingleton(FinancePaymentBloc.new);
    i.addLazySingleton(FinanceRecordBloc.new);
    i.addLazySingleton(FinanceTypeBloc.new);
    i.addLazySingleton(FinanceStatusBloc.new);
    i.addLazySingleton(FinanceTargetBloc.new);
    i.addLazySingleton(FinanceRecordController.new);
    i.addLazySingleton(FinanceTypeController.new);
    i.addLazySingleton(DashboardController.new);
  }

  @override
  void routes(r) {
    r.module('/', module: DashboardModule());
    r.module('/record', module: RecordModule());
    r.module('/type', module: TypeModule());
    r.module('/saving', module: SavingModule());
    r.module('/target', module: TargetModule());
    r.child('/about', child: (context) => const AboutPage());
  }
}
