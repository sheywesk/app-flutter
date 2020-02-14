import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<String>signInWithEmailAndPassword(String _email, String _senha);
  Future<String> createUserWithEmailAndPassword(String email, String senha);
  Future<void> signOut();
  Future<String> getCurrentUser();
}
class Auth implements BaseAuth{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String _email, String _senha) async{
   FirebaseUser user= await firebaseAuth.
                             signInWithEmailAndPassword(email: _email, password: _senha);

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String senha) async{
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
    return user.uid;

  }
  Future<String> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {

    return await firebaseAuth.signOut();
  }


}