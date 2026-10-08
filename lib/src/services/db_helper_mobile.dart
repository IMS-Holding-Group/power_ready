import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'storage_interface.dart';
import '../models/home_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

/// تنفيذ التخزين للموبايل باستخدام SQLite
class DbHelperMobile implements StorageInterface {
  static final DbHelperMobile instance = DbHelperMobile._init();
  static Database? _database;

  DbHelperMobile._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('powerready.db');
    return _database!;
  }

  @override
  Future<void> init() async {
    await database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE homes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        roof_area REAL NOT NULL,
        direction TEXT NOT NULL,
        shadow TEXT NOT NULL,
        monthly_consumption REAL NOT NULL,
        structural_quality TEXT,
        simulation_data TEXT,
        readiness_score REAL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        phone TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        city TEXT,
        phone TEXT,
        email TEXT,
        created_at TEXT
      )
    ''');

    // إنشاء مستخدم افتراضي
    final now = DateTime.now().toIso8601String();
    await db.insert('user', {
      'name': 'مستخدم PowerReady',
      'city': '',
      'phone': '',
      'email': '',
      'created_at': now,
    });
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('''
          ALTER TABLE homes ADD COLUMN structural_quality TEXT
        ''');
      } catch (e) {}

      try {
        await db.execute('''
          ALTER TABLE homes ADD COLUMN simulation_data TEXT
        ''');
      } catch (e) {}

      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            city TEXT NOT NULL,
            phone TEXT NOT NULL,
            created_at TEXT
          )
        ''');
      } catch (e) {}
    }

    if (oldVersion < 3) {
      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            city TEXT,
            phone TEXT,
            email TEXT,
            created_at TEXT
          )
        ''');
        
        // التحقق من وجود مستخدم، إن لم يوجد قم بإنشاء واحد افتراضي
        final userCheck = await db.query('user');
        if (userCheck.isEmpty) {
          final now = DateTime.now().toIso8601String();
          await db.insert('user', {
            'name': 'مستخدم PowerReady',
            'city': '',
            'phone': '',
            'email': '',
            'created_at': now,
          });
        }
      } catch (e) {}
    }
  }

  @override
  Future<int> insertHome(HomeModel home) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final homeWithTimestamp = home.copyWith(createdAt: now);
    return await db.insert('homes', homeWithTimestamp.toMap());
  }

  @override
  Future<List<HomeModel>> getHomes() async {
    final db = await database;
    final result = await db.query('homes', orderBy: 'created_at DESC');
    return result.map((map) => HomeModel.fromMap(map)).toList();
  }

  @override
  Future<HomeModel?> getHomeById(int id) async {
    final db = await database;
    final result = await db.query(
      'homes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return HomeModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> updateHome(HomeModel home) async {
    final db = await database;
    return await db.update(
      'homes',
      home.toMap(),
      where: 'id = ?',
      whereArgs: [home.id],
    );
  }

  @override
  Future<int> deleteHome(int id) async {
    final db = await database;
    return await db.delete(
      'homes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> insertRequest(RequestModel request) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final requestWithTimestamp = RequestModel(
      name: request.name,
      city: request.city,
      phone: request.phone,
      createdAt: now,
    );

    final map = requestWithTimestamp.toMap();
    map.remove('id');
    return await db.insert('requests', map);
  }

  @override
  Future<List<RequestModel>> getRequests() async {
    final db = await database;
    final result = await db.query('requests', orderBy: 'created_at DESC');
    return result.map((map) => RequestModel.fromMap(map)).toList();
  }

  @override
  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    
    if (result.isNotEmpty) {
      final existingId = result.first['id'] as int;
      return await db.update(
        'user',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [existingId],
      );
    } else {
      // إذا لم يوجد مستخدم، قم بإنشاء واحد جديد
      final now = DateTime.now().toIso8601String();
      final userWithTimestamp = user.copyWith(createdAt: now);
      return await db.insert('user', userWithTimestamp.toMap());
    }
  }

  @override
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

/// دالة للحصول على مثيل التخزين للموبايل
StorageInterface getStorageInstance() => DbHelperMobile.instance;

