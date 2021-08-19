import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_tracker/models/movie.dart';
import 'package:movie_tracker/services/database.dart';
import 'package:movie_tracker/shared/size_config.dart';
import 'package:movie_tracker/shared/styles.dart';
import 'package:permission_handler/permission_handler.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  bool loading = false;
  String name = '';
  String director = '';
  String poster = '';

  bool error = false;

  final _formKey = GlobalKey<FormState>();

  getImage() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
      String imgString = Movie.posterToBase64String(await image!.readAsBytes());
      setState(() {
        poster = imgString;
      });
    }
  }

  late File _image = File("");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Movie',
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
                      _image.path != ""
                          ? Container(
                              child: Image.file(_image),
                              height: SizeConfig.safeBlockVertical * 35,
                            )
                          : Placeholder(
                              strokeWidth: SizeConfig.safeBlockVertical * 0.1,
                              color: Colors.black26,
                              fallbackHeight: SizeConfig.safeBlockVertical * 35,
                              fallbackWidth: double.infinity,
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
                          'Upload poster',
                          style: TextStyle(
                              color: yellow,
                              fontSize: SizeConfig.safeBlockVertical * 2),
                        ),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      TextFormField(
                        cursorColor: yellow,
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
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(green)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              error = false;
                            });
                            if (poster != '') {
                              setState(() {
                                loading = true;
                              });
                              Movie movie = Movie(
                                  name: name,
                                  director: director,
                                  poster: poster);
                              await DatabaseService.instance.create(movie);
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                error = true;
                              });
                            }
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5),
                        ),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      error
                          ? Text(
                              'Please upload image',
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
