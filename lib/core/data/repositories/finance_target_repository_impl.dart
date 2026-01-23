import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/domain/repositories/finance_target_repository.dart';
import 'package:finance_control/core/enums/finance_category.dart';
import 'package:finance_control/core/model/finance_target_model.dart';
import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceTargetRepositoryImpl implements FinanceTargetRepository {
  final InitialDatabase database;

  FinanceTargetRepositoryImpl(this.database);

  @override
  Future<List<FinanceTargetModel>> getAll() async {
    final db = await database.database;
    final result = await db.query(
      'finance_target',
      orderBy: 'created_at DESC',
    );
    return result.map(FinanceTargetModel.fromMap).toList();
  }

  @override
  Future<FinanceTargetModel> getById(int id) async {
    final db = await database.database;
    final result = await db.query(
      'finance_target',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return FinanceTargetModel.fromMap(result.first);
  }

  @override
  Future<int> create(FinanceTargetModel model) async {
    final db = await database.database;
    
    final typeModel = FinanceTypeModel(
      name: model.label,
      financeCategory: FinanceCategory.income,
      icon: 'savings',
      color: '#4CAF50',
      isActive: true,
      hasLimit: false,
      limitValue: 0,
    );

    final typeId = await db.insert(
      'finance_types',
      typeModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final targetWithTypeId = model.copyWith(typeId: typeId);

    final targetId = await db.insert(
      'finance_target',
      targetWithTypeId.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return targetId;
  }

  @override
  Future<void> update(FinanceTargetModel model) async {
    final db = await database.database;
    if (model.id == null) throw Exception('ID não pode ser nulo');

    await db.update(
      'finance_types',
      {'name': model.label},
      where: 'id = ?',
      whereArgs: [model.typeId],
    );

    await db.update(
      'finance_target',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;
    
    final target = await getById(id);
    
    final recordsWithType = await db.query(
      'finance_records',
      where: 'type_id = ?',
      whereArgs: [target.typeId],
      limit: 1,
    );

    if (recordsWithType.isNotEmpty) {
      throw Exception(
        'Não é possível excluir esta meta: existem registros vinculados ao tipo.',
      );
    }

    await db.delete(
      'finance_types',
      where: 'id = ?',
      whereArgs: [target.typeId],
    );

    await db.delete(
      'finance_target',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> totalTargetValue() async {
    final db = await database.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(target_value), 0.0) as total FROM finance_target',
    );
    final value = result.first['total'];
    return value is int
        ? value.toDouble()
        : (value as double? ?? 0.0);
  }
}
