import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/users.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'user_database.db';
  static const String userTable = 'user';


  Future<Database> initDatabase() async {
    String databasePath = await getDatabasesPath();
    print("Location :" + databasePath);
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path,
        version: 8, onCreate: _createDatabase, onUpgrade: _upgradeDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $userTable(
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT,
      studentId TEXT,
      password TEXT,
      level TEXT,
      gender TEXT,
      imagePath TEXT
    )
  ''');
  }

  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 8) {
      await db.execute('ALTER TABLE $userTable ADD COLUMN imagePath TEXT');
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(userTable, user);
  }

  Future<String?> getUserImagePath(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      userTable,
      columns: ['imagePath'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result[0]['imagePath'] as String?;
    } else {
      return null;
    }
  }

  
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    if (user['email'] == null) {
      throw ArgumentError('User email cannot be null');
    }
    return await db.update(
      userTable,
      {
        ...user,
        'imagePath': user['imagePath'], 
      },
      where: 'email = ?',
      whereArgs: [user['email']!],
    );
  }



  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(userTable);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        studentId: maps[i]['studentId'],
        password: maps[i]['password'],
        level: maps[i]['level'], 
      );
    });
  }

  Future<User?> getUser(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (users.isNotEmpty) {
      return User(
        id: users[0]['id'],
        name: users[0]['name'],
        email: users[0]['email'],
        studentId: users[0]['studentId'],
        password: users[0]['password'],
        level: users[0]['level'],
        gender: users[0]['gender'],
      );
    } else {
      return null;
    }
  }
}
//20200187@stud.fci-cu.edu.eg
//14567891
//\/data/user/0/com.example.assignment1/databases
//