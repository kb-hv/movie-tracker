import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_tracker/models/movie.dart';
import 'package:movie_tracker/screens/home/edit_movie.dart';
import 'package:movie_tracker/services/database.dart';
import 'package:movie_tracker/shared/size_config.dart';
import 'package:movie_tracker/shared/styles.dart';

class MovieSearch extends SearchDelegate<Movie> {
  late Future<List<Movie>> movies;
  MovieSearch() {
    movies = DatabaseService.instance.readAll();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black45,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: green,
      ),
      onPressed: () {
        close(context, Movie(name: "name", director: "director", poster: ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
      child: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (query != '') {
              final results = snapshot.data!.where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()) ||
                  element.director.toLowerCase().contains(query.toLowerCase()));
              if (results.length == 0)
                return Center(
                  child: Text('No movies found!'),
                );
              return ListView(
                  children: results
                      .map<Widget>((movie) => Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: cardBorderStyle,
                            child: ListTile(
                              title: Text(
                                movie.name,
                                textAlign: TextAlign.justify,
                              ),
                              subtitle: Text(movie.director),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditMovie(movie: movie),
                                        ),
                                      );
                                      close(
                                          context,
                                          Movie(
                                              name: "name",
                                              director: "director",
                                              poster: ""));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Are you sure?'),
                                              content: Text(
                                                  'This will delete "${movie.name}". Click OK to proceed.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await DatabaseService
                                                        .instance
                                                        .delete(movie.id);
                                                    close(
                                                        context,
                                                        Movie(
                                                            name: "name",
                                                            director:
                                                                "director",
                                                            poster: ""));
                                                    Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.black45,
                                                      textColor: Colors.white,
                                                      msg:
                                                          "${movie.name} has been deleted!",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList());
            }
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
      child: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (query != '') {
              final results = snapshot.data!.where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()) ||
                  element.director.toLowerCase().contains(query.toLowerCase()));
              if (results.length == 0)
                return Center(
                  child: Text('No movies found!'),
                );
              return ListView(
                  children: results
                      .map<Widget>(
                        (movie) => Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: cardBorderStyle,
                          child: ListTile(
                            title: Text(
                              movie.name,
                              textAlign: TextAlign.justify,
                            ),
                            subtitle: Text(movie.director),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditMovie(movie: movie),
                                      ),
                                    );
                                    close(
                                        context,
                                        Movie(
                                            name: "name",
                                            director: "director",
                                            poster: ""),);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text(
                                              'This will delete "${movie.name}". Click OK to proceed.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await DatabaseService.instance
                                                    .delete(movie.id);
                                                close(
                                                  context,
                                                  Movie(
                                                      name: "name",
                                                      director: "director",
                                                      poster: ""),
                                                );
                                                Fluttertoast.showToast(
                                                  backgroundColor:
                                                      Colors.black45,
                                                  textColor: Colors.white,
                                                  msg:
                                                      "${movie.name} has been deleted!",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList());
            }
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
