class FinanceTargetMovementModel {
  final int? id;
  final int targetId;
  final String type;
  final double value;
  final String? description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceTargetMovementModel({
    this.id,
    required this.targetId,
    required this.type,
    required this.value,
    this.description,
    required this.date,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'target_id': targetId,
      'type': type,
      'value': value,
      'description': description,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FinanceTargetMovementModel.fromMap(Map<String, dynamic> map) {
    return FinanceTargetMovementModel(
      id: map['id'],
      targetId: map['target_id'],
      type: map['type'],
      value: (map['value'] as num).toDouble(),
      description: map['description'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  FinanceTargetMovementModel copyWith({
    int? id,
    int? targetId,
    String? type,
    double? value,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceTargetMovementModel(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      value: value ?? this.value,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FinanceTargetMovementModel(id: $id, targetId: $targetId, type: $type, value: $value, description: $description, date: $date, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
