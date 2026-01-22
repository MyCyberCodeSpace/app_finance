import 'package:finance_control/core/enums/finance_category.dart';

class FinanceTypeModel {
  final int? id;
  final String name;
  final FinanceCategory financeCategory;
  final String? icon;
  final String? color;
  final bool isActive;
  final DateTime createdAt;
  final bool hasLimit;
  final double limitValue;

  FinanceTypeModel({
    this.id,
    required this.name,
    required this.financeCategory,
    this.icon,
    this.color,
    this.isActive = true,
    DateTime? createdAt,
    required this.hasLimit,
    required this.limitValue,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'finance_category': financeCategory.name,
      'icon': icon,
      'color': color,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'has_limit': hasLimit ? 1 : 0,
      'limit_value': limitValue,
    };
  }

  factory FinanceTypeModel.fromMap(Map<String, dynamic> map) {
    return FinanceTypeModel(
      id: map['id'],
      name: map['name'],
      financeCategory: FinanceCategory.values.byName(
        map['finance_category'],
      ),
      icon: map['icon'],
      color: map['color'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      hasLimit: map['has_limit'] == 1,
      limitValue: map['limit_value'],
    );
  }

  FinanceTypeModel copyWith({
    int? id,
    String? name,
    FinanceCategory? financeCategory,
    String? icon,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    bool? hasLimit,
    double? limitValue,
  }) {
    return FinanceTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      financeCategory: financeCategory ?? this.financeCategory,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      hasLimit: hasLimit ?? this.hasLimit,
      limitValue: limitValue ?? this.limitValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinanceTypeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
