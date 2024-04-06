import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:assignment1/Model/users.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'user_database.db';
  static const String userTable = 'user';

  // Open the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDatabase() async {
    String databasePath = await getDatabasesPath();
    print("Location :" + databasePath);
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create the database tables
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        studentId TEXT,
        password TEXT
      )
    ''');
  }

  // Insert user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(userTable, user);
  }

  // Update user in the database
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      userTable,
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Delete user from the database
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all users from the database
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
      );
    });
  }
}
