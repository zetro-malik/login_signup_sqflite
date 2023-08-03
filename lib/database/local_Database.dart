import 'package:login_signup_sqflite/model/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
//SINGLETON

  //static instance to use
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //for initializing instace of this class
  DatabaseHelper._privateConstructor();

//DATABASE

  //reference variable of database...
  static Database? _database;

  //initialize or get database from file
  Future<Database> initializeDatabase() async {
    String dbpath = await getDatabasesPath();
    dbpath = dbpath + "/mydb2.db";
    var database = await openDatabase(dbpath, version: 1, onCreate: _createdb);
    return database;
  }

  //if initializing then create table for database
  void _createdb(Database db, int newversion) {
    // creations of tables
    String query = '''create table person
                    (
                      ID INTEGER PRIMARY KEY AUTOINCREMENT,
                      username TEXT,
                      password TEXT
                       ) 
                    ''';
    db.execute(query);
    print('table created..');
  }

//for initializing instace of this class
  Future<Database> get database async {
    // if(_database==null)
    //     _database=await initializeDatabase();
    _database ??= await initializeDatabase();

    return _database!;
  }

  Future<int> insertUser(Person obj) async {
    Database db = await instance.database;

    int id = await db.insert("person", obj.toMap());

    return id;
  }

  Future<bool> checkUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query("person",
        where: "username=? and password=?", whereArgs: [username, password]);

    bool check = true;
    if (data.isEmpty) {
      check = false;
    }
    return check;
  }
}
