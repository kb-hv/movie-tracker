import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/auth/google_auth.dart';
import 'package:movie_tracker/screens/home/home.dart';
import 'package:provider/provider.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return GoogleAuth();
    } else {
      return Home();
    }
  }
}