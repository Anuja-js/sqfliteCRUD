import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String userTable = 'user_table';
  String colId = 'id';
  String colName = 'name';
  String colQualification = 'qualification';
  String colAge = 'age';
  String colPhone = 'phone';
  String colDescription = 'description';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');

    var usersDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return usersDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
            '$colQualification TEXT, $colAge INTEGER, $colPhone INTEGER, $colDescription TEXT)');
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    var result = await db.query(userTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.insert(userTable, user.toMap());
    return result;
  }

  Future<int> updateUser(User user) async {
    Database db = await this.database;
    var result = await db.update(userTable, user.toMap(),
        where: '$colId = ?', whereArgs: [user.id]);
    return result;
  }

  Future<int> deleteUser(int id) async {
    Database db = await this.database;
    var result =
    await db.rawDelete('DELETE FROM $userTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $userTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  Future<List<User>> getUserList() async {
    var userMapList = await getUserMapList();
    int count = userMapList.length;

    List<User> userList = [];
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMapObject(userMapList[i]));
    }

    return userList;
  }
}
