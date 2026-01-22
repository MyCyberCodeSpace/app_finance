class FinanceSavingsModel {
  final int? id;
  final String label;
  final double value;
  final DateTime updatedAt;

  FinanceSavingsModel({
    required this.id,
    required this.label,
    required this.value,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'total_saving': value,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory FinanceSavingsModel.fromMap(Map<String, dynamic> map) {
    return FinanceSavingsModel(
      id: map['id'],
      label: map['label'],
      value: map['total_saving'],
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  FinanceSavingsModel copyWith({
    int? id,
    String? label,
    double? value,
    DateTime? updatedAt,
  }) {
    return FinanceSavingsModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
