import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Model/user.dart';
import 'database.dart';
import 'package:obvio/Services/database.dart';

class AuthService{

  final FirebaseAuth auth = FirebaseAuth.instance;

  String getUid(FirebaseUser user)
  {
    return user.uid;
  }
  User userFromFirebaseUser(FirebaseUser user)
  {

    return user != null ? User(uid : user.uid) : null ;
  }

  // Stream<User> get user{
  //   return auth.onAuthStateChanged
  //    //   .map((FirebaseUser user) => userFromFirebaseUser(user));
  //        .map(userFromFirebaseUser);
  // }
  //sign in anon
  Future signInAnon() async
  {
    try {
      AuthResult result = await auth.signInAnonymously();
      FirebaseUser user = result.user;
      return userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password , String name , String username) async
  {
    String id = email;
    String image = "https://firebasestorage.googleapis.com/v0/b/obvio-20210.appspot.com/o/shirley1.jpg?alt=media&token=ada5fcff-b990-4763-8673-c530b0ba23f2";
    try{
      AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid : user.uid).updateUserData(name , username , email , password ,id ,image);

      return user;
     // return userFromFirebaseUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  Future signInWithEmailAndPassword(String email, String password) async
  {
    try{
      AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
      //return userFromFirebaseUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  Future signOut() async
  {
    try {
      return await auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  forgotPassWord(String email)async{
    auth.sendPasswordResetEmail(email: email).then((value) {
    }).catchError((e){
      print(" Forgot Password error is $e");
    });
  }
}