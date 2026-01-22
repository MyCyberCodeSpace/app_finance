import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FilterExpansionCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const FilterExpansionCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gray.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashColor: AppColors.gray.shade50,
            highlightColor: AppColors.gray.shade50,
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.blue,
                size: 24,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.gray.shade800,
              ),
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}
