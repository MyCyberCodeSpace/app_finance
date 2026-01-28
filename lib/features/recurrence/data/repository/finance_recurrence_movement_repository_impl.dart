import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/features/recurrence/domain/repository/finance_recurrence_movement_repository.dart';
import 'package:finance_control/features/recurrence/domain/model/finance_recurrence_movement_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceRecurrenceMovementRepositoryImpl
    implements FinanceRecurrenceMovementRepository {
  final InitialDatabase database;

  FinanceRecurrenceMovementRepositoryImpl(this.database);

  @override
  Future<List<FinanceRecurrenceMovementModel>> getAll() async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence_movements',
      orderBy: 'execution_date DESC',
    );

    return result.map(FinanceRecurrenceMovementModel.fromMap).toList();
  }

  @override
  Future<List<FinanceRecurrenceMovementModel>> getByRecurrenceId(
    int recurrenceId,
  ) async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence_movements',
      where: 'recurrence_id = ?',
      whereArgs: [recurrenceId],
      orderBy: 'execution_date DESC',
    );

    return result.map(FinanceRecurrenceMovementModel.fromMap).toList();
  }

  @override
  Future<FinanceRecurrenceMovementModel> getById(int id) async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence_movements',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('Movement with id $id not found');
    }

    return FinanceRecurrenceMovementModel.fromMap(result.first);
  }

  @override
  Future<int> create(FinanceRecurrenceMovementModel model) async {
    final db = await database.database;

    final id = await db.insert(
      'finance_recurrence_movements',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<void> update(FinanceRecurrenceMovementModel model) async {
    final db = await database.database;

    if (model.id == null) {
      throw Exception('ID cannot be null on update');
    }

    await db.update(
      'finance_recurrence_movements',
      model.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;

    await db.delete(
      'finance_recurrence_movements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<FinanceRecurrenceMovementModel>> getMovementsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database.database;

    final result = await db.query(
      'finance_recurrence_movements',
      where: 'execution_date BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'execution_date DESC',
    );

    return result.map(FinanceRecurrenceMovementModel.fromMap).toList();
  }
}
