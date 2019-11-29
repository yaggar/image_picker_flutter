import 'dart:async';
import 'dart:io';

import 'package:image_picker_flutter/models/user.model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProviderHelper {
  DBProviderHelper._();

  static final DBProviderHelper db = DBProviderHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "avatar TEXT," 
          "blocked BIT"
          ")");
    });
  }

  newUser(User newUser) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into User (id,first_name,last_name,avatar,blocked)"
        " VALUES (?,?,?,?,?)",
        [id, newUser.firstName, newUser.lastName, newUser.avatar,newUser.blocked]);
    return raw;
  }

  blockOrUnblock(User user) async {
    final db = await database;
    User blocked = User(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
        blocked: !user.blocked);
    var res = await db.update("User", blocked.toMap(),
        where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  updateUser(User newUser) async {
    final db = await database;
    var res = await db.update("User", newUser.toMap(),
        where: "id = ?", whereArgs: [newUser.id]);
    return res;
  }

  Future<User> getUser(int id) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  Future<List<User>> getBlockedUsers() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM User WHERE blocked=1");
    var res = await db.query("User", where: "blocked = ? ", whereArgs: [1]);

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  deleteUser(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from User");
  }
}