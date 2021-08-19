import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_tracker/models/movie.dart';
import 'package:movie_tracker/screens/home/add_movie.dart';
import 'package:movie_tracker/screens/home/edit_movie.dart';
import 'package:movie_tracker/screens/home/search_movie.dart';
import 'package:movie_tracker/services/auth.dart';
import 'package:movie_tracker/services/database.dart';
import 'package:movie_tracker/shared/size_config.dart';
import 'package:movie_tracker/shared/styles.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Movie> movies = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    refreshMovies();
  }

  Future refreshMovies() async {
    setState(() {
      isLoading = true;
    });
    this.movies = await DatabaseService.instance.readAll();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final user = Provider.of<User?>(context);
    final photoUrl = user!.photoURL;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          './assets/images/logo.png',
          height: SizeConfig.safeBlockHorizontal * 12.5,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: MovieSearch(),
              );
              refreshMovies();
            },
            icon: Icon(
              Icons.search,
              size: SizeConfig.safeBlockVertical * 3.5,
            ),
          ),
          PopupMenuButton(
              padding: EdgeInsets.symmetric(
                  vertical: 0, horizontal: SizeConfig.safeBlockHorizontal * 4),
              iconSize: SizeConfig.safeBlockVertical * 5,
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(photoUrl ?? ""),
              ),
              // color: Colors.black,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Center(
                      child: Image.network(
                        photoUrl ?? "",
                        height: SizeConfig.safeBlockVertical * 10,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.safeBlockVertical),
                      child: Center(
                          child: Text(
                        'Hi, ${user.displayName}!',
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  PopupMenuItem(
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                      'This will log you out. Click OK to proceed.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('CANCEL',
                                          style:
                                              TextStyle(color: Colors.black45)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await AuthService().signOut();
                                        Fluttertoast.showToast(
                                          backgroundColor: Colors.black45,
                                          textColor: Colors.white,
                                          msg: "You've been logged out!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          //
                                          //
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ];
              }),
        ],
      ),
      body: isLoading
          ? loadingIndicator
          : movies.length == 0
              ? Center(child: Text('There are no movies yet!'))
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 1,
                      horizontal: SizeConfig.safeBlockHorizontal * 1),
                  child: ListView.builder(
                      itemCount: movies.length + 1,
                      itemBuilder: (context, index) {
                        if (index == movies.length) {
                          return Container(
                            height: SizeConfig.safeBlockVertical * 8,
                          );
                        }
                        var poster = base64Decode(movies[index].poster);
                        return Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: cardBorderStyle,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(
                                              SizeConfig.safeBlockVertical * 5),
                                          scrollable: true,
                                          content: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.memory(
                                                  poster,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .safeBlockVertical *
                                                      2,
                                                ),
                                                SelectableText(
                                                    'Movie: ${movies[index].name}'),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .safeBlockVertical *
                                                      2,
                                                ),
                                                SelectableText(
                                                    'Director: ${movies[index].director}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 0.7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          alignment: FractionalOffset.topCenter,
                                          image: MemoryImage(
                                            poster,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  movies[index].name,
                                  textAlign: TextAlign.justify,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditMovie(movie: movies[index]),
                                          ),
                                        );
                                        refreshMovies();
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
                                                    'This will delete "${movies[index].name}". Click OK to proceed.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await DatabaseService
                                                          .instance
                                                          .delete(
                                                              movies[index].id);
                                                      refreshMovies();
                                                      Fluttertoast.showToast(
                                                        backgroundColor:
                                                            Colors.black45,
                                                        textColor: Colors.white,
                                                        msg:
                                                            "${movies[index].name} has been deleted!",
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
                              )
                            ],
                          ),
                        );
                      }),
                ),
      floatingActionButton: Container(
        width: SizeConfig.safeBlockHorizontal * 15,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: SizeConfig.safeBlockVertical * 4,
            color: Colors.white,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddMovie(),
              ),
            );
            refreshMovies();
          },
        ),
      ),
    );
  }
}
