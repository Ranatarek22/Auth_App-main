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

    return await openDatabase(path,
        version: 5, onCreate: _createDatabase, onUpgrade: _upgradeDatabase);
  }

  // Create the database table
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        studentId TEXT,
        password TEXT,
        level TEXT,
        gender Text // Add the level column
      )
    ''');
  }

  // Upgrade the database table
  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE $userTable ADD COLUMN gender TEXT');
    }
  }

  // Insert user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;

    // Check if the email already exists
    List<Map<String, dynamic>> existingUsers = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [user['email']],
    );
    if (existingUsers.isNotEmpty) {
      // Email already exists, return error code
      return -1;
    }

    // Email doesn't exist, insert user
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
        level: maps[i]['level'], // Include level in the User object
      );
    });
  }

  // Get user from the database
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
