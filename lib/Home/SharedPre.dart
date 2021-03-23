import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPre
{
  var uid,fname,lname;
  void setUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;

  }

  SharedPre()
  {
    setValues();
  }
    void setValues() async
    {
      SharedPreferences shared = await SharedPreferences.getInstance();

      Firestore.instance.collection("Ravan").document(uid).get().then((value) =>
      {
        print(value.data["fname"]),
        fname = value.data["fname"],
        lname = value.data["lname"]
      }
      );

       shared.setString("User_fname", fname);
       shared.setString("User_lname", lname);
    }

}
/*
class SharedPre extends StatefulWidget {
  @override
  _SharedPreState createState() => _SharedPreState();
}


class _SharedPreState extends State<SharedPre> {
  var uid;
  var fname,lname;
  void setUserData()
  async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
      print(uid);
    });
  }

  void setValues() async
  {
    SharedPreferences shared = await SharedPreferences.getInstance();

    Firestore.instance.collection("Ravan").document(uid).get().then((value) =>  print(value.data["fname"]) );

    shared.setString("User_fname", fname );
    shared.setString("User_lname", lname);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValues();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/