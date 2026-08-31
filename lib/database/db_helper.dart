import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ngebensin.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE logs (
        id TEXT PRIMARY KEY,
        fuel TEXT,
        station TEXT,
        liters REAL,
        total REAL,
        date TEXT,
        vehicle_id TEXT
      )
    ''');

    // Seed default vehicle
    final defaultVehicle = Vehicle(
      id: 'v-legacy',
      name: 'Motor Utama',
      type: 'motor',
    );
    await db.insert('vehicles', defaultVehicle.toMap());
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create vehicles table
      await db.execute('''
        CREATE TABLE vehicles (
          id TEXT PRIMARY KEY,
          name TEXT,
          type TEXT
        )
      ''');

      // Add vehicle_id column to logs table
      await db.execute('ALTER TABLE logs ADD COLUMN vehicle_id TEXT;');

      // Insert default vehicle
      await db.rawInsert(
        'INSERT INTO vehicles (id, name, type) VALUES (?, ?, ?)',
        ['v-legacy', 'Motor Utama', 'motor'],
      );

      // Update existing logs
      await db.rawUpdate(
        'UPDATE logs SET vehicle_id = ? WHERE vehicle_id IS NULL',
        ['v-legacy'],
      );
    }
  }

  Future<int> insertLog(LogEntry log) async {
    final db = await database;
    return await db.insert('logs', log.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<LogEntry>> getLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('logs', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return LogEntry.fromMap(maps[i]);
    });
  }

  Future<int> deleteLog(String id) async {
    final db = await database;
    return await db.delete('logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateLog(LogEntry log) async {
    final db = await database;
    return await db.update('logs', log.toMap(), where: 'id = ?', whereArgs: [log.id]);
  }

  Future<int> clearAllLogs() async {
    final db = await database;
    return await db.delete('logs');
  }

  // Vehicle CRUD Operations
  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Vehicle>> getVehicles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vehicles');
    return List.generate(maps.length, (i) {
      return Vehicle.fromMap(maps[i]);
    });
  }

  Future<int> deleteVehicle(String id) async {
    final db = await database;
    // Delete all logs for this vehicle as well
    await db.delete('logs', where: 'vehicle_id = ?', whereArgs: [id]);
    return await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateVehicle(Vehicle vehicle) async {
    final db = await database;
    return await db.update('vehicles', vehicle.toMap(), where: 'id = ?', whereArgs: [vehicle.id]);
  }
}
