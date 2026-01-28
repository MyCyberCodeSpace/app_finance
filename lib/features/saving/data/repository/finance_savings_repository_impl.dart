import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/features/saving/domain/repository/finance_savings_repository.dart';
import 'package:finance_control/features/saving/domain/model/finance_savings_model.dart';
import 'package:finance_control/features/saving/domain/model/finance_saving_movement_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceSavingsRepositoryImpl
    implements FinanceSavingsRepository {
  final InitialDatabase database;

  FinanceSavingsRepositoryImpl(this.database);

  @override
  Future<List<FinanceSavingsModel>> getAll() async {
    final db = await database.database;

    final result = await db.query(
      'finance_saving',
      orderBy: 'label ASC',
    );

    return result.map(FinanceSavingsModel.fromMap).toList();
  }

  @override
  Future<void> create(FinanceSavingsModel model) async {
    final db = await database.database;

    await db.insert('finance_saving', {
      ...model.toMap(),
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(FinanceSavingsModel model) async {
    final db = await database.database;

    if (model.id == null) {
      throw Exception('FinanceSavings id cannot be null on update');
    }

    await db.update(
      'finance_saving',
      {
        ...model.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;

    await db.delete(
      'finance_saving',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<FinanceSavingsModel> getById(int id) async {
    final db = await database.database;

    final result = await db.query(
      'finance_saving',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('FinanceSavings with id $id not found');
    }

    return FinanceSavingsModel.fromMap(result.first);
  }

  @override
  Future<double> getTotalSavings() async {
    final db = await database.database;

    final result = await db.rawQuery(
      'SELECT SUM(total_saving) as total FROM finance_saving',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }

    return 0.0;
  }

  @override
  Future<int> addMovement(FinanceSavingMovementModel movement) async {
    final db = await database.database;

    final movementId = await db.insert(
      'finance_saving_movements',
      movement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return movementId;
  }

  @override
  Future<List<FinanceSavingMovementModel>> getMovementsBySavingId(int savingId) async {
    final db = await database.database;

    final result = await db.query(
      'finance_saving_movements',
      where: 'saving_id = ?',
      whereArgs: [savingId],
      orderBy: 'date DESC',
    );

    return result.map(FinanceSavingMovementModel.fromMap).toList();
  }

  @override
  Future<void> updateMovement(FinanceSavingMovementModel movement) async {
    final db = await database.database;

    if (movement.id == null) {
      throw Exception('Movement id cannot be null on update');
    }

    await db.update(
      'finance_saving_movements',
      {
        ...movement.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [movement.id],
    );
  }

  @override
  Future<void> deleteMovement(int movementId) async {
    final db = await database.database;

    await db.delete(
      'finance_saving_movements',
      where: 'id = ?',
      whereArgs: [movementId],
    );
  }

  @override
  Future<double> getTotalMovementsBySavingId(int savingId) async {
    final db = await database.database;

    final entradas = await db.rawQuery(
      'SELECT COALESCE(SUM(value), 0.0) as total FROM finance_saving_movements WHERE saving_id = ? AND type = ?',
      [savingId, 'entrada'],
    );

    final saidas = await db.rawQuery(
      'SELECT COALESCE(SUM(value), 0.0) as total FROM finance_saving_movements WHERE saving_id = ? AND type = ?',
      [savingId, 'saida'],
    );

    final totalEntradas = (entradas.first['total'] as num?)?.toDouble() ?? 0.0;
    final totalSaidas = (saidas.first['total'] as num?)?.toDouble() ?? 0.0;

    return totalEntradas - totalSaidas;
  }
}
