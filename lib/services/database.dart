import 'dart:async';
import 'package:movie_tracker/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  static Database? _database;

  // open a database connection
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB('movies.db');
    return _database;
  }

  Future _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE $tableName (
    ${TableFields.id} $idType,
    ${TableFields.director} $stringType,
    ${TableFields.name} $stringType,
    ${TableFields.poster} $stringType)
    ''');
  }

  // INSERT
  Future create(Movie movie) async {
    final db = await instance.database;
    final id = await db!.insert(tableName, movie.movieToJson());
    return movie.copy(id);
  }

  // READ
  Future<List<Movie>> readAll() async {
    final db = await instance.database;
    final orderBy = '${TableFields.name} ASC';
    final result = await db!.query(tableName, orderBy: orderBy);
    return result.map((json) => Movie.jsonToMovie(json)).toList();
  }

  // UPDATE
  Future<int> update(Movie movie) async {
    final db = await instance.database;
    return await db!.update(tableName, movie.movieToJson(),
        where: '${TableFields.id} = ${movie.id}');
  }

  // DELETE
  Future<int> delete(int? id) async {
    final db = await instance.database;
    return await db!.delete(
        tableName,
        where: '${TableFields.id} = ${id}');
  }
}
