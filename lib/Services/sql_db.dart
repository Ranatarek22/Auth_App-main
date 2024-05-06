import 'package:assignment1/Model/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/store.dart';
import '../Model/fav_store.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'user_database.db';
  static const String userTable = 'user';
  static const String storeTable = 'stores';

  Future<Database> initDatabase() async {
    String databasePath = await getDatabasesPath();
    print("Location: $databasePath");
    String path = join(databasePath, dbName);

    return await openDatabase(
      path,
      version: 25, // Updated version number
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
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

    await db.execute('''
      CREATE TABLE $storeTable(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        createdAt TEXT NULL,
        image TEXT Not NULL
      )
    ''');
    await db.execute('''
    CREATE TABLE favoriteStores(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      store_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES $userTable(id),
      FOREIGN KEY (store_id) REFERENCES $storeTable(id)
    )
  ''');
  }

  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 25) {
      var tables = await db.query("sqlite_master",
          where: "type = 'table' AND name = '$storeTable'");
      if (tables.isNotEmpty) {
        await db.execute('''
        CREATE TABLE temp_$storeTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          createdAt TEXT NULL,
          image TEXT Not NULL
        )
      ''');

        await db.execute('''
        INSERT INTO temp_$storeTable
        SELECT * FROM $storeTable
      ''');

        await db.execute('''
        DROP TABLE $storeTable
      ''');

        await db.execute('''
        ALTER TABLE temp_$storeTable RENAME TO $storeTable
      ''');
      }
      await db.execute('''
    CREATE TABLE favoriteStores(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      store_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES $userTable(id),
      FOREIGN KEY (store_id) REFERENCES $storeTable(id)
    )
  ''');
      await _insertInitialStores(db);
    }
  }

  Future<void> _insertInitialStores(Database db) async {
    await db.insert(
      storeTable,
      {
        'name': 'Hyper 1',
        'latitude': 123.456,
        'longitude': 456.789,
        'createdAt': DateTime.now().toString(),
        'image': 'assets/images/book_store.png',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      storeTable,
      {
        'name': 'Pizza King',
        'latitude': 987.654,
        'longitude': 654.321,
        'createdAt': DateTime.now().toString(),
        'image': 'assets/images/default_store.png',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<UserData?> getUserById(String userId) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      userTable,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (users.isNotEmpty) {
      return UserData(
        id: users[0]['id'].toString(),
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

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<UserData>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(userTable);
    return List.generate(maps.length, (i) {
      return UserData(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        email: maps[i]['email'],
        studentId: maps[i]['studentId'],
        password: maps[i]['password'],
        level: maps[i]['level'],
      );
    });
  }

  Future<UserData?> getUser(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (users.isNotEmpty) {
      return UserData(
        id: users[0]['id'].toString(),
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

  Future<int> insertStore(Map<String, dynamic> storeData) async {
    Database db = await database;

    // Fetch store with the same ID from the database
    List<Map<String, dynamic>> existingStore = await db.query(
      storeTable,
      where: 'id = ?',
      whereArgs: [storeData['id']],
    );

    // If no record with the same ID exists, insert the store into the database
    if (existingStore.isEmpty) {
      return await db.insert(storeTable, storeData);
    } else {
      // Return a value to indicate that the store was not inserted
      return -1; // You can choose any value to indicate failure
    }
  }

  Future<List<Store>> getStoresFromDatabase() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(storeTable);
    List<Store> stores = List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        createdAt: maps[i]['createdAt'],
        image: maps[i]['image'] ?? '', // Ensure correct retrieval of image data
      );
    });

    // Print image paths for each store
    stores.forEach((store) {
      print('Store ID: ${store.id}, Image Path: ${store.image}');
    });

    return stores;
  }

  Future<void> insertFavoriteStore(String userId, String storeId) async {
    Database db = await database;
    await db.insert(
      'favoriteStores',
      {
        'user_id': userId,
        'store_id': storeId,
      },
      conflictAlgorithm:
          ConflictAlgorithm.ignore, // or replace as per your requirement
    );
  }

  Future<List<FavoriteStore>> getFavoriteStores(String userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'favoriteStores',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<FavoriteStore> favoriteStores = [];
    for (Map<String, dynamic> map in maps) {
      // Fetch store details using store ID
      Store? store = await getStoreById(map['store_id'].toString());
      if (store != null) {
        favoriteStores.add(FavoriteStore(
          id: map['id'],
          userId: map['user_id'].toString(),
          storeId: map['store_id'].toString(),
          store: store,
        ));
      }
    }
    return favoriteStores;
  }

  Future<Store?> getStoreById(String storeId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'stores',
      where: 'id = ?',
      whereArgs: [storeId],
    );

    if (maps.isNotEmpty) {
      return Store(
        id: maps[0]['id'].toString(),
        name: maps[0]['name'],
        latitude: maps[0]['latitude'],
        longitude: maps[0]['longitude'],
        createdAt: maps[0]['createdAt'],
        image: maps[0]['image'],
      );
    } else {
      return null;
    }
  }


  Future<void> deleteAllStores() async {
    Database db = await database;
    await db.delete(storeTable);
  }
}
