
class FinanceStatusModel {
  final int id;
  final String label; 

  FinanceStatusModel({
    required this.id,
    required this.label,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': label,
    };
  }

  factory FinanceStatusModel.fromMap(Map<String, dynamic> map) {
    return FinanceStatusModel(
      id: map['id'],
      label: map['status'],
    );
  }
}
