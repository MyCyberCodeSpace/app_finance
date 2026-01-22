import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/domain/repositories/finance_status_repository.dart';
import 'package:finance_control/core/model/finance_status_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceStatusRepositoryImpl implements FinanceStatusRepository {
  final InitialDatabase database;

  FinanceStatusRepositoryImpl(this.database);

  @override
  Future<List<FinanceStatusModel>> getAll() async {
    final Database db = await database.database;

    final result = await db.query('finance_status');

    return result.map(FinanceStatusModel.fromMap).toList();
  }

  @override
  Future<void> create(FinanceStatusModel model) async {
    final Database db = await database.database;

    await db.insert(
      'finance_status',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(FinanceStatusModel model) async {
    final Database db = await database.database;

    await db.update(
      'finance_status',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final Database db = await database.database;

    await db.delete(
      'finance_status',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<FinanceStatusModel> getById(int id) async {
    final Database db = await database.database;

    final List<Map<String, dynamic>> result = await db.query(
      'finance_status',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return FinanceStatusModel.fromMap(result.first);
  }
}
