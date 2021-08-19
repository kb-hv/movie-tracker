import 'dart:convert';
import 'dart:io';
import 'package:movie_tracker/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_tracker/models/movie.dart';
import 'package:movie_tracker/services/database.dart';
import 'package:movie_tracker/shared/styles.dart';
import 'package:permission_handler/permission_handler.dart';

class EditMovie extends StatefulWidget {
  final Movie movie;
  EditMovie({required this.movie});
  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  bool loading = false;
  String name = '';
  String director = '';
  String poster = '';

  final _formKey = GlobalKey<FormState>();

  late File _image = File("");

  getImage() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
      String imgString =
          await Movie.posterToBase64String(await image!.readAsBytes());
      setState(() {
        poster = imgString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit ${widget.movie.name}',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: SizeConfig.safeBlockHorizontal,
            ),
          ),
        ),
      ),
      body: loading
          ? loadingIndicator
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical,
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal * 10,
                      ),
                      _image.path != ''
                          ? Container(
                              child: Image.file(_image),
                              height: SizeConfig.safeBlockVertical * 35,
                            )
                          : Container(
                              child: Image.memory(base64Decode(widget.movie.poster)),
                              height: SizeConfig.safeBlockVertical * 35,
                            ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: yellow,
                                width: SizeConfig.safeBlockVertical * 0.1)),
                        icon: Icon(
                          Icons.upload,
                          color: yellow,
                        ),
                        onPressed: () {
                          getImage();
                        },
                        label: Text(
                          'Change poster',
                          style: TextStyle(
                              color: yellow,
                              fontSize: SizeConfig.safeBlockVertical * 2),
                        ),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      TextFormField(
                        cursorColor: yellow,
                        initialValue: widget.movie.name,
                        decoration: textFieldDecor,
                        validator: (val) =>
                            val!.isEmpty ? "Enter name of movie" : null,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      TextFormField(
                        cursorColor: yellow,
                        initialValue: widget.movie.director,
                        decoration: textFieldDecor.copyWith(
                            labelText: 'Director of movie'),
                        validator: (val) =>
                            val!.isEmpty ? "Enter director of movie" : null,
                        onChanged: (val) {
                          setState(() {
                            director = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal * 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            if (name == '') {
                              name = widget.movie.name;
                            }
                            if (director == '') {
                              director = widget.movie.director;
                            }
                            if (poster == '') {
                              poster = widget.movie.poster;
                            }
                            Movie movie = Movie(
                                id: widget.movie.id,
                                name: name,
                                director: director,
                                poster: poster);
                            await DatabaseService.instance.update(movie);
                            Fluttertoast.showToast(
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              msg: "Movie has been edited!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              //
                              //
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(green)),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
