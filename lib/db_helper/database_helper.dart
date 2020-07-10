import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:aplikasi_diary/model/diary.dart';

class DatabaseHelper {
  static DatabaseHelper _dbHelper;
  static Database _database;  

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_dbHelper == null) {
      _dbHelper = DatabaseHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {

  //Untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'diary.db';

   //Create & Read database
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //Mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

    //Membuat tabel baru dengan nama diary
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        catatanisi TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('diary', orderBy: 'name');
    return mapList;
  }

//Create database
  Future<int> insert(Diary object) async {
    Database db = await this.database;
    int count = await db.insert('diary', object.toMap());
    return count;
  }
//Update database
  Future<int> update(Diary object) async {
    Database db = await this.database;
    int count = await db.update('diary', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [object.id]);
    return count;
  }

//Delete database
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('diary', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }

  Future<List<Diary>> getDiaryList() async {
    var diaryMapList = await select();
    int count = diaryMapList.length;
    List<Diary> diaryList = List<Diary>();
    for (int i=0; i<count; i++) {
      diaryList.add(Diary.fromMap(diaryMapList[i]));
    }
    return diaryList;
  }

}