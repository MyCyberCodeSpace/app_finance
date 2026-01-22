import 'package:finance_control/core/presentation/widgets/main_appbard.dart';
import 'package:finance_control/core/presentation/widgets/main_botton_navigator.dart';
import 'package:finance_control/core/presentation/widgets/app_drawer.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final int selectedPageIndex;
  final String text;
  final Widget body;
  final void Function() onPressedFloatingActionButton;
  final bool showMenuButton;

  const CustomScaffold({
    super.key,
    required this.selectedPageIndex,
    required this.text,
    required this.body,
    required this.onPressedFloatingActionButton,
    this.showMenuButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: mainAppBar(
        context: context,
        text: text,
        showMenuButton: showMenuButton,
      ),
      endDrawer: showMenuButton ? const AppDrawer() : null,
      bottomNavigationBar: MainBottomNavigator(
        selectedPageIndex: selectedPageIndex,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: body,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.backgroundColorBlack,
        onPressed: onPressedFloatingActionButton,

        child: Icon(Icons.add, size: 24, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}
