import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditDeletePopupMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EditDeletePopupMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.gray.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.more_vert,
          color: AppColors.gray.shade700,
          size: 20,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      color: Colors.white,
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_rounded,
                size: 20,
                color: AppColors.positiveBalance,
              ),
              const SizedBox(width: 12),
              const Text(
                'Editar',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_rounded,
                size: 20,
                color: AppColors.nevagativeBalance,
              ),
              const SizedBox(width: 12),
              Text(
                'Excluir',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.nevagativeBalance,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
