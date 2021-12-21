import 'package:assitant2/util/error/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseAuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() => _auth.currentUser;

  Future<UserCredential> createAccount(String email, String password) async {
    assert(email != null && email.isNotEmpty);
    assert(password != null && password.isNotEmpty);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPassword('كلمة سر ضعيفة');
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUse('البريد الالكتروني مستخدم بالفعل!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login(String email, String password) async {
    assert(email != null && email.isNotEmpty);
    assert(password != null && password.isNotEmpty);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFound('لم نتمكن من العثور على البريد!');
      } else if (e.code == 'wrong-password') {
        throw WrongPassword('كلمة سر غير صحيحة.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw SignInAborted('عملية تسجيل الدخول فشلت!');
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }
}
