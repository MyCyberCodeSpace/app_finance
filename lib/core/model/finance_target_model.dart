class FinanceTargetModel {
  final int? id;
  final String label;
  final double targetValue; 
  final double currentValue; 
  final DateTime? dueDate; 
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceTargetModel({
    this.id,
    required this.label,
    required this.targetValue,
    this.currentValue = 0,
    this.dueDate,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'target_value': targetValue,
      'current_value': currentValue,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FinanceTargetModel.fromMap(Map<String, dynamic> map) {
    return FinanceTargetModel(
      id: map['id'],
      label: map['label'],
      targetValue: map['target_value'],
      currentValue: map['current_value'] ?? 0,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  FinanceTargetModel copyWith({
    int? id,
    String? label,
    double? targetValue,
    double? currentValue,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceTargetModel(
      id: id ?? this.id,
      label: label ?? this.label,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
