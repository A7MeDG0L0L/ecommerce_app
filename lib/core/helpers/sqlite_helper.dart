import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseTables {
  DataBaseTables._();
  static const String products = 'products';
  static const String users = 'users';
  static const String favorites = 'favorites';
  static const String cart = 'cart';
}

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DataBaseTables.users} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        fullName TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DataBaseTables.favorites} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        productId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES ${DataBaseTables.users}(id),
        UNIQUE(userId, productId)
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DataBaseTables.cart} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        productId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES ${DataBaseTables.users}(id),
        UNIQUE(userId, productId)
      )
    ''');
  }

  // Info: favorites
  // Add to favorites
  Future<bool> addToFavorites(int userId, String productId) async {
    Database db = await instance.database;
    try {
      await db.insert(
        DataBaseTables.favorites,
        {
          'userId': userId,
          'productId': productId,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToCart(int userId, String productId) async {
    Database db = await instance.database;
    try {
      await db.insert(
        DataBaseTables.cart,
        {
          'userId': userId,
          'productId': productId,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFromFavorites(int userId, String productId) async {
    Database db = await instance.database;
    int count = await db.delete(
      DataBaseTables.favorites,
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );
    return count > 0;
  }

  Future<bool> removeFromCart(int userId, String productId) async {
    Database db = await instance.database;
    int count = await db.delete(
      DataBaseTables.cart,
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );
    return count > 0;
  }

  // Get all favorite productIds for a user
  Future<List<String>> getFavoriteProductsIds(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.favorites,
      columns: ['productId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((result) => result['productId'] as String).toList();
  }

  Future<List<String>> getCartProductsIds(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.cart,
      columns: ['productId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((result) => result['productId'] as String).toList();
  }

  // Check if a product is favorited by user
  Future<bool> isFavorite(int userId, String productId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.favorites,
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );
    return results.isNotEmpty;
  }

  Future<bool> isCart(int userId, String productId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      DataBaseTables.cart,
      where: 'userId = ? AND productId = ?',
      whereArgs: [userId, productId],
    );
    return results.isNotEmpty;
  }
}
