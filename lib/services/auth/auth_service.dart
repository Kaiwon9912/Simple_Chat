import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
    );
    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Use the uid from the authenticated user to set the document in Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'username': gUser.displayName,
      'email': gUser.email,
    });
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> Register(String username,String email, password) async
  {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      //Create new document for user
      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          'username': username,
          'email':email,
        }
      );
      return userCredential;
    }

    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

}