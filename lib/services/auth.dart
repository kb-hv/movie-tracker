import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final googleSignIn = GoogleSignIn();

  // auth change stream
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  // sign in with google
  Future signInWithGoogle() async {
    final user = await googleSignIn.signIn();
    if (user != null) {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      await _firebaseAuth.signInWithCredential(credential);
    }
  }

  // sign out
  Future signOut() async {
    try {
      await googleSignIn.disconnect();
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }


}
