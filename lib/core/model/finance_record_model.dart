class FinanceRecordModel {
  final int? id;
  final DateTime date;
  final int? dueDay;
  final double value;
  final int typeId;
  final int? statusId;
  final int paymentId;
  final String? description;
  final bool isRecurring;
  final int? totalInstallments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  FinanceRecordModel({
    this.id,
    required this.date,
    this.dueDay,
    required this.value,
    required this.typeId,
    required this.paymentId,
    this.statusId,
    this.description,
    this.isRecurring = false,
    this.totalInstallments,
    DateTime? createdAt,
    this.updatedAt,
    this.isDeleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'due_day': dueDay,
      'value': value,
      'type_id': typeId,
      'status_id': statusId,
      'payment_id': paymentId,
      'description': description,
      'is_recurring': isRecurring ? 1 : 0,
      'total_installments': totalInstallments,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory FinanceRecordModel.fromMap(Map<String, dynamic> map) {
    return FinanceRecordModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      dueDay: map['due_day'] is int ? map['due_day'] : null,
      value: map['value'],
      typeId: map['type_id'],
      statusId: map['status_id'],
      paymentId: map['payment_id'],
      description: map['description'],
      isRecurring: map['is_recurring'] == 1,
      totalInstallments: map['total_installments'],
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
    int? dueDay,
    double? value,
    int? typeId,
    int? statusId,
    int? paymentId,
    String? description,
    bool? isRecurring,
    int? installment,
    int? totalInstallments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return FinanceRecordModel(
      id: id ?? this.id,
      date: date ?? this.date,
      dueDay: dueDay ?? this.dueDay,
      value: value ?? this.value,
      typeId: typeId ?? this.typeId,
      statusId: statusId ?? this.statusId,
      paymentId: paymentId ?? this.paymentId,
      description: description ?? this.description,
      isRecurring: isRecurring ?? this.isRecurring,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
