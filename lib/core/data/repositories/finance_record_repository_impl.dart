import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/domain/params/finance_record_params.dart';
import 'package:finance_control/core/domain/repositories/finance_record_repository.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_record_model.dart';

class FinanceRecordRepositoryImpl implements FinanceRecordRepository {
  final InitialDatabase database;
  final FinanceTypeRepository financeTypeRepository;

  FinanceRecordRepositoryImpl(
    this.database,
    this.financeTypeRepository,
  );

  Future<void> _updateBalance(double value) async {
    final db = await database.database;

    final current = await getBalance();
    final newValue = current + value;

    await db.update(
      'finance_balance',
      {'total_balance': newValue},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<double> getBalance() async {
    final db = await database.database;

    final result = await db.query('finance_balance', limit: 1);

    if (result.isEmpty) return 0.0;

    return (result.first['total_balance'] as num).toDouble();
  }

  @override
  Future<void> setBalance(double value) async {
    final db = await database.database;
    await db.update(
      'finance_balance',
      {'total_balance': value},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<List<FinanceRecordModel>> getAll(
    FinanceRecordParams params,
  ) async {
    final db = await database.database;

    final whereClauses = <String>['is_deleted = 0'];
    final whereArgs = <Object?>[];

    if (params.startDate != null) {
      whereClauses.add('date >= ?');
      whereArgs.add(params.startDate!.toIso8601String());
    }
    if (params.endDate != null) {
      whereClauses.add('date <= ?');
      whereArgs.add(params.endDate!.toIso8601String());
    }

    if (params.financeCategory != null &&
        params.financeCategory!.isNotEmpty) {
      final placeholders = List.filled(
        params.financeCategory!.length,
        '?',
      ).join(',');

      whereClauses.add('''
      type_id IN (
        SELECT id FROM finance_types
        WHERE finance_category IN ($placeholders)
      )
    ''');
      whereArgs.addAll(params.financeCategory!.map((e) => e.name));
    }

    final result = await db.query(
      'finance_records',
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );

    if (params.financeType != null &&
        params.financeType!.isNotEmpty) {
      final typeIds = params.financeType!
          .where((e) => e.id != null)
          .map((e) => e.id!)
          .toSet();

      final list = result
          .map(FinanceRecordModel.fromMap)
          .where((record) => typeIds.contains(record.typeId))
          .toList();
      return list;
    }

    return result.map(FinanceRecordModel.fromMap).toList();
  }

  @override
  Future<void> create(FinanceRecordModel model) async {
    final db = await database.database;

    final type = await financeTypeRepository.getById(model.typeId);

    final impact = type.financeCategory == FinanceCategory.income
        ? model.value
        : -model.value;

    await db.insert('finance_records', model.toMap());
    await _updateBalance(impact);
  }

  @override
  Future<void> update(FinanceRecordModel model) async {
    final db = await database.database;

    final old = await db.query(
      'finance_records',
      where: 'id = ?',
      whereArgs: [model.id],
      limit: 1,
    );

    if (old.isEmpty) return;

    final oldModel = FinanceRecordModel.fromMap(old.first);

    final oldType = await financeTypeRepository.getById(
      oldModel.typeId,
    );
    final newType = await financeTypeRepository.getById(model.typeId);

    double oldImpact =
        oldType.financeCategory == FinanceCategory.income
        ? oldModel.value
        : -oldModel.value;

    double newImpact =
        newType.financeCategory == FinanceCategory.income
        ? model.value
        : -model.value;

    final balanceDifference = newImpact - oldImpact;

    await db.update(
      'finance_records',
      model.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );

    await _updateBalance(balanceDifference);
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;

    final result = await db.query(
      'finance_records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return;

    final model = FinanceRecordModel.fromMap(result.first);

    final type = await financeTypeRepository.getById(model.typeId);
    final impact = type.financeCategory == FinanceCategory.income
        ? model.value
        : -model.value;

    await db.update(
      'finance_records',
      {
        'is_deleted': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await _updateBalance(-impact);
  }
}
