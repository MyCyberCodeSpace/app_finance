import 'package:finance_control/core/presentation/utils/screen_by_index.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainBottomNavigator extends StatefulWidget {
  final int selectedPageIndex;
  const MainBottomNavigator({
    super.key,
    required this.selectedPageIndex,
  });

  @override
  State<MainBottomNavigator> createState() =>
      _MainBottomNavigatorState();
}

class _MainBottomNavigatorState extends State<MainBottomNavigator> {
  void _setScreen(int index) {
    if (index == widget.selectedPageIndex) return;

    final route = screenByIndex(index);
    Modular.to.navigate(route);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: AppColors.backgroundColorBlack,
      elevation: 10,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.center_focus_strong,
              label: 'Dashboard',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.widgets,
              label: 'Tipos',
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.savings,
              label: 'Economias',
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.add_alert_rounded,
              label: 'Metas',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = widget.selectedPageIndex == index;
    final color = isSelected
        ? AppColors.write
        : AppColors.opaqueWriteText;

    return InkWell(
      onTap: () => _setScreen(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
