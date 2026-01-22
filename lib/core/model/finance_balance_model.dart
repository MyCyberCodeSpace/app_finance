class FinanceBalanceModel {
  final int? id;
  final double value;

  FinanceBalanceModel({required this.id, required this.value});

  Map<String, dynamic> toMap() {
    return {'id': id, 'total_balance': value};
  }

  factory FinanceBalanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceBalanceModel(
      id: map['id'],
      value: map['total_balance'],
    );
  }

  FinanceBalanceModel copyWith({int? id, double? value}) {
    return FinanceBalanceModel(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }
}
