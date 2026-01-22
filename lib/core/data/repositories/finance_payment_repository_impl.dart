import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/domain/repositories/finance_payment_repository.dart';
import 'package:finance_control/core/model/finance_payment_model.dart';
import 'package:sqflite/sqflite.dart';

class FinancePaymentRepositoryImpl implements FinancePaymentRepository {
  final InitialDatabase database;

  FinancePaymentRepositoryImpl(this.database);

  @override
  Future<List<FinancePaymentModel>> getAll() async {
    final Database db = await database.database;

    final result = await db.query('finance_payment');

    return result.map(FinancePaymentModel.fromMap).toList();
  }

  @override
  Future<void> create(FinancePaymentModel model) async {
    final Database db = await database.database;

    await db.insert(
      'finance_payment',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(FinancePaymentModel model) async {
    final Database db = await database.database;

    await db.update(
      'finance_payment',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final Database db = await database.database;

    await db.delete(
      'finance_payment',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<FinancePaymentModel> getById(int id) async {
    final Database db = await database.database;

    final List<Map<String, dynamic>> result = await db.query(
      'finance_payment',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return FinancePaymentModel.fromMap(result.first);
  }
}
