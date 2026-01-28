class FinanceSavingMovementModel {
  final int? id;
  final int savingId;
  final String type;
  final double value;
  final String? description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinanceSavingMovementModel({
    this.id,
    required this.savingId,
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
      'saving_id': savingId,
      'type': type,
      'value': value,
      'description': description,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FinanceSavingMovementModel.fromMap(Map<String, dynamic> map) {
    return FinanceSavingMovementModel(
      id: map['id'],
      savingId: map['saving_id'],
      type: map['type'],
      value: map['value'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  FinanceSavingMovementModel copyWith({
    int? id,
    int? savingId,
    String? type,
    double? value,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinanceSavingMovementModel(
      id: id ?? this.id,
      savingId: savingId ?? this.savingId,
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
    return 'FinanceSavingMovementModel(id: $id, savingId: $savingId, type: $type, value: $value, description: $description, date: $date, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
