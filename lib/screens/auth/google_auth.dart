import 'package:flutter/material.dart';
import 'package:movie_tracker/services/auth.dart';
import 'package:movie_tracker/shared/size_config.dart';
import 'package:movie_tracker/shared/styles.dart';

class GoogleAuth extends StatefulWidget {
  const GoogleAuth({Key? key}) : super(key: key);

  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  AuthService _auth = AuthService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 5),
                child: Center(
                  child: Image.asset('./assets/images/logo.png'),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 10,),
              loading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loadingIndicator,
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        Text('Please wait')
                      ],
                    )
                  : OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white),
                      icon: Image.asset('./assets/images/google_signin.png',
                          width: SizeConfig.safeBlockVertical * 3),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await _auth.signInWithGoogle();
                        setState(() {
                          loading = false;
                        });
                      },
                      label: Padding(
                        padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1.5),
                        child: Text(
                          'Login with Google',
                          style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
