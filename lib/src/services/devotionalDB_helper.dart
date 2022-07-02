import 'dart:io';

import 'package:sqflite/sqflite.dart';
import '../models/devotional.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/devotional_plans.dart';
import '../models/note.dart';

class DevotionalDBHelper {
  DevotionalDBHelper._privateConstructor();

  static final DevotionalDBHelper instance = DevotionalDBHelper._privateConstructor();

  final String MIGRATION_STRING_IF_LESSTHAN_FIVE1 = 'ALTER TABLE devotional_table ADD COLUMN prayerBurden TEXT';
  final String MIGRATION_STRING_IF_LESSTHAN_FIVE2 =
      'INSERT INTO devotional_table (prayerBurden) SELECT prayer FROM devotional_table';

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print("await getDatabasesPath()");
    print(await getDatabasesPath());
    String path = join(await getDatabasesPath(), 'devotional_database.db');

    return await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE devotional_table(id INTEGER PRIMARY KEY, date TEXT, title TEXT, translation TEXT, memoryVerse TEXT, memoryVersePassage TEXT, fullPassage TEXT, fullText TEXT, bibleInAYear TEXT, image TEXT, prayerBurden TEXT, thoughtOfTheDay TEXT)',
    );
    await db.execute(
        'CREATE TABLE devotionalPlan_table(id TEXT, title TEXT, imageUrl TEXT, description TEXT, devotionals TEXT)');

    await db.execute('CREATE TABLE note_table(id INTEGER PRIMARY KEY, title TEXT, writeUp TEXT, date TEXT)');

    await db.execute(
        'CREATE TABLE bookmarked_devotional_table(id INTEGER PRIMARY KEY, date TEXT, title TEXT, translation TEXT, memoryVerse TEXT, memoryVersePassage TEXT, fullPassage TEXT, fullText TEXT, bibleInAYear TEXT, image TEXT, prayerBurden TEXT, thoughtOfTheDay TEXT)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (newVersion < 5) {
      db.execute(MIGRATION_STRING_IF_LESSTHAN_FIVE1);
      db.execute(MIGRATION_STRING_IF_LESSTHAN_FIVE2);
      print('migration......................');
    }
  }

  Future<dynamic> insertDevotionalList(List<Devotional> devotionalList) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();

    for (var devotional in devotionalList) {
      batch.insert("devotional_table", devotional.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    var result = batch.commit();
    return result;
  }

  Future<List<Devotional>> getDevotionalsDB() async {
    Database? db = await instance.database;

    // Query the table for all The Devotionals.
    var devotionals = await db!.query('devotional_table');

    List<Devotional> devList = devotionals.isNotEmpty ? devotionals.map((e) => Devotional.fromJson(e)).toList() : [];
    return devList;
  }

  Future<List<Devotional>> getDevotionalsDBForMonth(monthYearVal) async {
    Database? db = await instance.database;

    var devotionals = await db!.rawQuery("SELECT * FROM devotional_table WHERE date LIKE '%$monthYearVal%'");

    List<Devotional> devList = devotionals.isNotEmpty ? devotionals.map((e) => Devotional.fromJson(e)).toList() : [];
    return devList;
  }

  Future<dynamic> insertDevotionalPlan(DevotionalPlan devotionalPlan) async {
    Database? db = await instance.database;

    return await db?.insert("devotionalPlan_table", devotionalPlan.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DevotionalPlan>> getDevotionalPlansFromDB() async {
    Database? db = await instance.database;

    var devotionalPlans = await db!.query('devotionalPlan_table');

    List<DevotionalPlan> devPlanList =
        devotionalPlans.isNotEmpty ? devotionalPlans.map((e) => DevotionalPlan.fromJson(e)).toList() : [];
    return devPlanList;
  }

  Future<DevotionalPlan?> getDevotionalPlanFromDBWithID(devPlanID) async {
    List<DevotionalPlan> devPlans = await getDevotionalPlansFromDB();

    for (int i = 0; i < devPlans.length; i++) {
      if (devPlans[i].id == devPlanID) {
        return devPlans[i];
      }
    }
    return null;
  }

  Future<dynamic> insertBookMarkedDevotional(Devotional bookMarkedDevotional) async {
    Database? db = await instance.database;

    return await db?.insert("bookmarked_devotional_table", bookMarkedDevotional.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Devotional>> getBookMarkedDevotionalsFromDB() async {
    Database? db = await instance.database;

    var bookMarkedDevotionals = await db!.query('bookmarked_devotional_table');

    List<Devotional> bookMarkedDevotionalList =
        bookMarkedDevotionals.isNotEmpty ? bookMarkedDevotionals.map((e) => Devotional.fromJson(e)).toList() : [];
    return bookMarkedDevotionalList;
  }

  Future<dynamic> insertNote(Note note) async {
    Database? db = await instance.database;

    return await db?.insert("note_table", note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Note>> getNotesFromDB() async {
    Database? db = await instance.database;

    var notes = await db!.query("note_table");

    List<Note> noteList = notes.isNotEmpty ? notes.map((e) => Note.fromJson(e)).toList() : [];

    return noteList;
  }

  Future<dynamic> updateNote(Note note) async {
    Database? db = await instance.database;
    return await db!.rawUpdate(
        'UPDATE note_table SET title = ?, writeUp = ? WHERE date = ?', [note.title, note.writeUp, note.date]);
  }

  Future<dynamic> insertNoteListFromApiIntoDB(List<Note> noteList) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();

    for (var note in noteList) {
      batch.insert("note_table", note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    var result = batch.commit();
    return result;
  }

  Future<List<Note>> getNotewithDate(date) async {
    Database? db = await instance.database;

    var result = await db!.rawQuery("SELECT * FROM note_table WHERE date=?", ['$date']);

    List<Note> noteList = result.isNotEmpty ? result.map((e) => Note.fromJson(e)).toList() : [];
    return noteList;
  }
}
