import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PopupSelectOption<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color color;

  PopupSelectOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class PopupSelectField<T> extends StatelessWidget {
  final T selectedValue;
  final List<PopupSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? label;
  final IconData? labelIcon;

  const PopupSelectField({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.label,
    this.labelIcon,
  });

  PopupSelectOption<T> get _selectedOption {
    return options.firstWhere(
      (option) => option.value == selectedValue,
      orElse: () => options.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              if (labelIcon != null) ...[
                Icon(
                  labelIcon,
                  size: 20,
                  color: AppColors.gray.shade600,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        PopupMenuButton<T>(
          offset: const Offset(0, 68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          elevation: 8,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 72,
            maxWidth: MediaQuery.of(context).size.width - 72,
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          onSelected: onChanged,
          itemBuilder: (context) {
            return [
              PopupMenuItem<T>(
                enabled: false,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((option) {
                        final isSelected = option.value == selectedValue;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            onChanged(option.value);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: option.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    option.icon,
                                    color: option.color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: option.color,
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.gray.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedOption.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _selectedOption.icon,
                    color: _selectedOption.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedOption.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray.shade700,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.gray.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
