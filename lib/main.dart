import 'package:finance_control/app_module.dart';
import 'package:finance_control/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main(){
  return runApp(ModularApp(module: AppModule(), child: AppWidget()));
}