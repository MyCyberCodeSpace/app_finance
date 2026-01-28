import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_record_model.dart';
import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:finance_control/core/presentation/bloc/finance_record/finance_record_bloc_event.dart';
import 'package:finance_control/core/presentation/controllers/finance_record_controller.dart';
import 'package:finance_control/core/presentation/widgets/confirm_delete_dialog.dart';
import 'package:finance_control/core/presentation/widgets/edit_delete_popup_menu.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FinanceRecordTile extends StatelessWidget {
  final FinanceRecordModel record;
  final FinanceTypeModel type;
  late final FinanceRecordController financeRecordController;

  FinanceRecordTile({
    super.key,
    required this.record,
    required this.type,
  }) {
    financeRecordController = Modular.get<FinanceRecordController>();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Excluir registro',
        content: 'Tem certeza que deseja excluir este registro? '
            'Essa ação não pode ser desfeita.',
        onConfirm: () {},
      ),
    );

    if (confirm == true) {
      financeRecordController.financeRecordBloc.add(
        DeleteFinanceRecordEvent(record.id!),
      );
    }
  }

  Color _valueColor() {
    switch (type.financeCategory) {
      case FinanceCategory.income:
        return AppColors.positiveBalance;
      case FinanceCategory.expense:
        return AppColors.nevagativeBalance;
      case FinanceCategory.investiment:
        return AppColors.blue;
    }
  }

  Color _categoryColor() {
    switch (type.financeCategory) {
      case FinanceCategory.income:
        return AppColors.positiveBalance;
      case FinanceCategory.expense:
        return AppColors.nevagativeBalance;
      case FinanceCategory.investiment:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'R\$ ${record.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _valueColor(),
                    ),
                  ),
                ),
                EditDeletePopupMenu(
                  onEdit: () {
                    Modular.to.pushNamed(
                      '/record/${record.id}',
                      arguments: record,
                    );
                  },
                  onDelete: () => _confirmDelete(context),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Tag(label: type.name, color: AppColors.gray.shade700),
                _Tag(
                  label: type.financeCategory.label,
                  color: _categoryColor(),
                ),
              ],
            ),

            if (record.description != null &&
                record.description!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                record.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.gray.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
