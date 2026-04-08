import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('hydration.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        weight_kg REAL NOT NULL DEFAULT 70,
        activity_level TEXT NOT NULL DEFAULT 'Medium',
        unit TEXT NOT NULL DEFAULT 'ml',
        daily_goal_ml INTEGER NOT NULL DEFAULT 2100,
        last_open_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_intake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        intake_date TEXT NOT NULL UNIQUE,
        intake_ml INTEGER NOT NULL DEFAULT 0,
        goal_ml INTEGER NOT NULL DEFAULT 2100
      )
    ''');

    await db.insert('settings', {
      'id': 1,
      'weight_kg': 70.0,
      'activity_level': 'Medium',
      'unit': 'ml',
      'daily_goal_ml': 2100,
      'last_open_date': null,
    });
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS water_entries');
      await db.execute('DROP TABLE IF EXISTS settings');
      await db.execute('DROP TABLE IF EXISTS daily_intake');

      await _createDB(db, newVersion);
    }
  }

  Future<void> ensureDailyIntakeRow({
    required String intakeDate,
    required int goalMl,
  }) async {
    final db = await database;

    await db.insert(
      'daily_intake',
      {
        'intake_date': intakeDate,
        'intake_ml': 0,
        'goal_ml': goalMl,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Map<String, dynamic>?> getDailyIntakeByDate(String intakeDate) async {
    final db = await database;

    final result = await db.query(
      'daily_intake',
      where: 'intake_date = ?',
      whereArgs: [intakeDate],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<List<Map<String, dynamic>>> getDailyIntakeRange({
    required String startDate,
    required String endDate,
  }) async {
    final db = await database;

    return db.query(
      'daily_intake',
      where: 'intake_date >= ? AND intake_date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'intake_date DESC',
    );
  }

  Future<void> upsertDailyIntake({
    required String intakeDate,
    required int intakeMl,
    required int goalMl,
  }) async {
    final db = await database;

    await db.insert(
      'daily_intake',
      {
        'intake_date': intakeDate,
        'intake_ml': intakeMl,
        'goal_ml': goalMl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDailyGoalForDate({
    required String intakeDate,
    required int goalMl,
  }) async {
    final db = await database;

    await db.update(
      'daily_intake',
      {'goal_ml': goalMl},
      where: 'intake_date = ?',
      whereArgs: [intakeDate],
    );
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;

    final result = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<void> upsertSettings({
    required double weightKg,
    required String activityLevel,
    required String unit,
    required int dailyGoalMl,
    String? lastOpenDate,
  }) async {
    final db = await database;

    await db.insert(
      'settings',
      {
        'id': 1,
        'weight_kg': weightKg,
        'activity_level': activityLevel,
        'unit': unit,
        'daily_goal_ml': dailyGoalMl,
        'last_open_date': lastOpenDate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLastOpenDate(String lastOpenDate) async {
    final db = await database;

    await db.update(
      'settings',
      {'last_open_date': lastOpenDate},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}