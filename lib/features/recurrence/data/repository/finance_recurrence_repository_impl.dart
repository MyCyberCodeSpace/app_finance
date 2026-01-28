import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/features/recurrence/domain/repository/finance_recurrence_repository.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceRecurrenceRepositoryImpl implements FinanceRecurrenceRepository {
  final InitialDatabase database;

  FinanceRecurrenceRepositoryImpl(this.database);

  @override
  Future<List<FinanceRecurrenceModel>> getAll() async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence',
      orderBy: 'start_date DESC',
    );

    return result.map(FinanceRecurrenceModel.fromMap).toList();
  }

  @override
  Future<List<FinanceRecurrenceModel>> getActive() async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'start_date DESC',
    );

    return result.map(FinanceRecurrenceModel.fromMap).toList();
  }

  @override
  Future<FinanceRecurrenceModel> getById(int id) async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('Recurrence with id $id not found');
    }

    return FinanceRecurrenceModel.fromMap(result.first);
  }

  @override
  Future<int> create(FinanceRecurrenceModel model) async {
    final db = await database.database;

    final id = await db.insert(
      'finance_recurrence',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<void> update(FinanceRecurrenceModel model) async {
    final db = await database.database;

    if (model.id == null) {
      throw Exception('ID cannot be null on update');
    }

    await db.update(
      'finance_recurrence',
      model.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;

    await db.delete(
      'finance_recurrence',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleActive(int id, bool isActive) async {
    final db = await database.database;

    await db.update(
      'finance_recurrence',
      {
        'is_active': isActive ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override

  Future<List<FinanceRecurrenceModel>> getExpiredRecurrences() async {
    final db = await database.database;

    final now = DateTime.now().toIso8601String();

    final result = await db.query(
      'finance_recurrence',
      where: 'is_active = ? AND end_date IS NOT NULL AND end_date < ?',
      whereArgs: [1, now],
      orderBy: 'end_date DESC',
    );

    return result.map(FinanceRecurrenceModel.fromMap).toList();
  }
}
