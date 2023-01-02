import 'package:app_tournament/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
      FirestoreService().newUsersReport();
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }

  /// Anonymous Firebase login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      FirestoreService().newUsersReport();
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final _firebaseAuth = FirebaseAuth.instance;
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
