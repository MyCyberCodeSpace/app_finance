import 'package:finance_control/core/domain/repositories/finance_record_repository.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FinanceRecordController {
  final FinanceRecordBloc financeRecordBloc =
      Modular.get<FinanceRecordBloc>();

  ValueNotifier<double> currentBalance = ValueNotifier<double>(0);

  final FinanceRecordRepository financeRecordRepository =
      Modular.get<FinanceRecordRepository>();

  void getBalance() async {
    currentBalance.value = await financeRecordRepository.getBalance();
  }

  Future<void> setBalance(double value) async {
    await financeRecordRepository.setBalance(value);
    currentBalance.value = value;
  }
}
