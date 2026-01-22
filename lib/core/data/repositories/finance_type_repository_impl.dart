import 'package:finance_control/core/data/datasource/database/initial_database.dart';
import 'package:finance_control/core/domain/repositories/finance_type_repository.dart';
import 'package:finance_control/core/model/finance_type_model.dart';
import 'package:sqflite/sqflite.dart';

class FinanceTypeRepositoryImpl implements FinanceTypeRepository {
  final InitialDatabase database;

  FinanceTypeRepositoryImpl(this.database);

  @override
  Future<FinanceTypeModel> getById(int id) async {
    final Database db = await database.database;

    final List<Map<String, dynamic>> result = await db.query(
      'finance_types',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return FinanceTypeModel.fromMap(result.first);
  }

  @override
  Future<List<FinanceTypeModel>> getAll() async {
    final Database db = await database.database;

    final List<Map<String, dynamic>> result = await db.query(
      'finance_types',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );

    return result
        .map((map) => FinanceTypeModel.fromMap(map))
        .toList();
  }

  @override
  Future<void> create(FinanceTypeModel model) async {
    final Database db = await database.database;

    await db.insert(
      'finance_types',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(FinanceTypeModel model) async {
    final Database db = await database.database;

    if (model.id == null) {
      throw Exception('FinanceType id cannot be null on update');
    }

    if (model.isActive == false) {
      final result = await db.query(
        'finance_records',
        where: 'type_id = ?',
        whereArgs: [model.id],
        limit: 1,
      );

      if (result.isNotEmpty) {
        throw Exception(
          'Não é possível desativar este tipo: existem registros vinculados.',
        );
      }
    }

    await db.update(
      'finance_types',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database.database;

    final result = await db.query(
      'finance_records',
      where: 'type_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      throw Exception(
        'Não é possível excluir o tipo: existem registros vinculados.',
      );
    }

    await db.update(
      'finance_types',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
