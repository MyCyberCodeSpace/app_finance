class FinanceRecordModel {
  final int? id;
  final DateTime date;
  final double value;
  final int typeId;
  final int paymentId;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  FinanceRecordModel({
    this.id,
    required this.date,
    required this.value,
    required this.typeId,
    required this.paymentId,
    this.description,
    DateTime? createdAt,
    this.updatedAt,
    this.isDeleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'value': value,
      'type_id': typeId,
      'payment_id': paymentId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory FinanceRecordModel.fromMap(Map<String, dynamic> map) {
    return FinanceRecordModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      value: map['value'],
      typeId: map['type_id'],
      paymentId: map['payment_id'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      isDeleted: map['is_deleted'] == 1,
    );
  }

  FinanceRecordModel copyWith({
    int? id,
    DateTime? date,
    double? value,
    int? typeId,
    int? paymentId,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return FinanceRecordModel(
      id: id ?? this.id,
      date: date ?? this.date,
      value: value ?? this.value,
      typeId: typeId ?? this.typeId,
      paymentId: paymentId ?? this.paymentId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
