import 'package:finance_control/features/recurrence/domain/enums/recurrence_type.dart';
import 'package:finance_control/core/enums/finance_category.dart';

class FinanceRecurrenceModel {
  final int? id;
  final String label;
  final double value;
  final int paymentId;
  final RecurrenceType recurrenceType;
  final int? dueDay;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final bool isActive;
  final FinanceCategory financeCategory;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceRecurrenceModel({
    this.id,
    required this.label,
    required this.value,
    required this.paymentId,
    required this.recurrenceType,
    this.dueDay,
    required this.startDate,
    this.endDate,
    this.description,
    this.isActive = true,
    required this.financeCategory,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'payment_id': paymentId,
      'recurrence_type': recurrenceType.name,
      'due_day': dueDay,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'description': description,
      'is_active': isActive ? 1 : 0,
      'finance_category': financeCategory.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FinanceRecurrenceModel.fromMap(Map<String, dynamic> map) {
    return FinanceRecurrenceModel(
      id: map['id'],
      label: map['label'],
      value: map['value'],
      paymentId: map['payment_id'],
      recurrenceType: RecurrenceType.values.firstWhere(
        (e) => e.name == map['recurrence_type'],
      ),
      dueDay: map['due_day'],
      startDate: DateTime.parse(map['start_date']),
      endDate:
          map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      description: map['description'],
      isActive: map['is_active'] == 1,
      financeCategory: FinanceCategory.values.firstWhere(
        (e) => e.name == map['finance_category'],
      ),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  FinanceRecurrenceModel copyWith({
    int? id,
    String? label,
    double? value,
    int? paymentId,
    RecurrenceType? recurrenceType,
    int? dueDay,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isActive,
    FinanceCategory? financeCategory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceRecurrenceModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      paymentId: paymentId ?? this.paymentId,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      dueDay: dueDay ?? this.dueDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      financeCategory: financeCategory ?? this.financeCategory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
