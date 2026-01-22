import 'package:finance_control/core/data/datasource/database/initial_dataset_finance_record.dart';
import 'package:finance_control/core/data/datasource/database/initial_dataset_finance_savings.dart';
import 'package:finance_control/core/data/datasource/database/initial_dataset_finance_target.dart';
import 'package:finance_control/core/data/datasource/database/initial_dataset_finance_types.dart';
import 'package:finance_control/core/data/datasource/database/initial_dataset_payment_types.dart';
import 'package:finance_control/core/data/datasource/database/initial_dataset_status_types.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class InitialDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      p.join(await getDatabasesPath(), 'finances.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE finance_balance (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          total_balance REAL NOT NULL
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_types (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          finance_category TEXT NOT NULL,
          icon TEXT,
          color TEXT,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          has_limit INTEGER NOT NULL,
          limit_value REAL NOT NULL
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          due_day INTEGER,
          value REAL NOT NULL,
          type_id INTEGER NOT NULL,
          status_id INTEGER,
          payment_id INTEGER,
          description TEXT,
          is_recurring INTEGER NOT NULL,
          total_installments INTEGER,
          created_at TEXT NOT NULL,
          updated_at TEXT,
          is_deleted INTEGER NOT NULL,
          FOREIGN KEY (payment_id) REFERENCES finance_payment (id),
          FOREIGN KEY (status_id) REFERENCES finance_status (id),
          FOREIGN KEY (type_id) REFERENCES finance_types (id)
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_status (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT NOT NULL
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_payment (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          payment_name TEXT NOT NULL
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_savings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          label TEXT NOT NULL,
          total_saving REAL NOT NULL,
          updated_at TEXT NOT NULL
        )
        ''');

        await db.execute('''
        CREATE TABLE finance_target (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          label TEXT NOT NULL,
          target_value REAL NOT NULL,
          current_value REAL NOT NULL,
          due_date TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT
        );
        ''');
        
        for (final payment in initialFinancePaymentTypes) {
          await db.insert('finance_payment', payment.toMap());
        }

        for (final status in initialFinanceStatusTypes) {
          await db.insert('finance_status', status.toMap());
        }

        for (final type in initialFinanceTypes) {
          await db.insert('finance_types', type.toMap());
        }

        for (final financeRecord in initialDataset) {
          await db.insert('finance_records', financeRecord.toMap());
        }

        for (final saving in initialDatasetFinanceSavings) {
          await db.insert('finance_savings', saving.toMap());
        }

        for (final target in initialFinanceTarget) {
          await db.insert('finance_target', target.toMap());
        }

        await db.insert('finance_balance', {
          'total_balance': 10280.6,
        });
      },
    );
  }
}
