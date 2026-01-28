class FinanceRecurrenceMovementModel {
  final int? id;
  final int recurrenceId;
  final double value;
  final String? description;
  final DateTime executionDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceRecurrenceMovementModel({
    this.id,
    required this.recurrenceId,
    required this.value,
    this.description,
    required this.executionDate,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recurrence_id': recurrenceId,
      'value': value,
      'description': description,
      'execution_date': executionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FinanceRecurrenceMovementModel.fromMap(Map<String, dynamic> map) {
    return FinanceRecurrenceMovementModel(
      id: map['id'],
      recurrenceId: map['recurrence_id'],
      value: map['value'],
      description: map['description'],
      executionDate: DateTime.parse(map['execution_date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  FinanceRecurrenceMovementModel copyWith({
    int? id,
    int? recurrenceId,
    double? value,
    String? description,
    DateTime? executionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceRecurrenceMovementModel(
      id: id ?? this.id,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      value: value ?? this.value,
      description: description ?? this.description,
      executionDate: executionDate ?? this.executionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
