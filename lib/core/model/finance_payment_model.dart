class FinancePaymentModel {
  final int? id;
  final String paymentName;

  FinancePaymentModel({required this.id, required this.paymentName});

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payment_name': paymentName,
    };
  }

  factory FinancePaymentModel.fromMap(Map<String, dynamic> map) {
    return FinancePaymentModel(
      id: map['id'],
      paymentName: map['payment_name'],
    );
  }
}
