import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_tracker/screens/screen_wrapper.dart';
import 'package:movie_tracker/services/auth.dart';
import 'package:movie_tracker/shared/styles.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(selectionColor: yellow),
          accentColor: green,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: green),),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: ScreenWrapper(),
      ),
    );
  }
}
