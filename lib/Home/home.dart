import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Home/MyProfile.dart';
import 'package:obvio/Home/NewPosts.dart';
import 'package:obvio/Home/SharedPre.dart';
import 'package:obvio/Home/UplaodImage.dart';
import 'package:obvio/Home/UserEvents.dart';
import 'package:obvio/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String fname;
  String lname;
  String imageUrl;
  String uid;
  TabController controller;

  final AuthService auth = AuthService();

  void setUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
      print(uid);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
//    SharedPre();
    controller = TabController(vsync: this, length: 4);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Ecstasy",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/msgbox');
                },
                child: Icon(
                  Icons.chat,
                  size: 23,
                ),
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

        ),

          /*new TabBar(
              labelColor: Colors.black,
              controller: controller,
              tabs: <Widget>[
                Tab(child: Container(color: Colors.lightBlue,
                    child: Icon(Icons.home, color: Colors.black,))),
                Tab(child: Container(color: Colors.purple,
                    child: Icon(Icons.event, color: Colors.black,)),),
                Tab(child: Container(color: Colors.green,
                    child: Icon(Icons.add, color: Colors.black,)),),
                Tab(child: Container(color: Colors.deepOrange,
                    child: Icon(Icons.person_outline, color: Colors.black))),
              ]
          ),*/

        body: NewPosts(),
      /*TabBarView(
          controller: controller,
          children: <Widget>[

            NewPosts(),
            UserEvents(),
            UploadMyImage(),
            MyProfilePage(),
          ],
        ) */ //NewsFeed()
    );
  }
}