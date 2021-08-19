import 'dart:convert';
import 'dart:typed_data';

final String tableName = 'movies';

class TableFields {
  static final List<String> values = [id, name, director, poster];
  static final String id = '_id';
  static final String name = 'name';
  static final String director = 'director';
  static final String poster = 'poster';
}

class Movie {
  final int? id;
  final String name;
  final String director;
  final String poster;
  Movie({this.id, required this.name, required this.director, required this.poster});

  static String posterToBase64String(Uint8List data) {
    return base64Encode(data);
  }

  Map<String, Object?> movieToJson() {
    return {
      TableFields.id: id,
      TableFields.name: name,
      TableFields.director: director,
      TableFields.poster: poster
    };
  }

  static Movie jsonToMovie(Map<String, Object?> json) {
    return Movie(
        id: json[TableFields.id] as int,
        name: json[TableFields.name] as String,
        director: json[TableFields.director] as String,
        poster: json[TableFields.poster] as String);
  }

  Movie copy(int id) {
    return Movie(id: this.id, name: this.name, director: this.director, poster: this.poster);
  }
}
