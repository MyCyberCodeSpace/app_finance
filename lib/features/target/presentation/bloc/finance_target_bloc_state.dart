import 'package:finance_control/core/model/finance_target_model.dart';

abstract class FinanceTargetBlocState {
  const FinanceTargetBlocState();
}

class FinanceTargetInitialState extends FinanceTargetBlocState {}

class FinanceTargetLoadingState extends FinanceTargetBlocState {}

class FinanceTargetLoadedState extends FinanceTargetBlocState {
  final List<FinanceTargetModel> listTargets;
  const FinanceTargetLoadedState(this.listTargets);
}

class FinanceTargetTotalLoadedState extends FinanceTargetBlocState {
  final double totalTarget;
  const FinanceTargetTotalLoadedState(this.totalTarget);
}

class FinanceTargetErrorState extends FinanceTargetBlocState {
  final String message;
  const FinanceTargetErrorState(this.message);
}
