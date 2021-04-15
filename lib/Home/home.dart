import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Home/MsgBox.dart';
import 'package:obvio/Home/MyProfile.dart';
import 'package:obvio/Home/NewPosts.dart';
import 'package:obvio/Home/Requests.dart';
import 'package:obvio/Home/SearchHere.dart';
import 'package:obvio/Home/SharedPre.dart';
import 'package:obvio/Home/UplaodImage.dart';
import 'package:obvio/Home/UserEvents.dart';
import 'package:obvio/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Notifications.dart';

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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
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

    controller = TabController(vsync: this, length: 5);
    firebaseMessaging.configure(
        onMessage: (message ) async{
          print(" Configuration ");
          print("Message ${message['notification']['title']}");
       //   return Scaffold.of(context).showSnackBar(SnackBar(content: message["notification"]["title"] , duration: Duration(seconds: 3),));
        },
        onResume: (message) async {
          print("Screen is ${(message['data']['screen'])}");
          setState(() {
            if(message['data']['screen'] == 'MsgBox()')
              {
                print("msgbx");
                print(" Configuration ");
                Navigator.push(context , MaterialPageRoute(builder: (BuildContext context ){
                  return MsgBox();
                }));
              }
            else if(message['data']['screen'] == 'Notification')
              {
                controller.animateTo(3);
              }
            else if(message['data']['screen'] == 'Requests')
            {
              controller.animateTo(3);
              Navigator.push(
                context , MaterialPageRoute(
                builder: (BuildContext context)
                    {
                      return Requests();
                    }
              )
              );
            }
          });
        },
        onLaunch: (message) async{
          setState(() {
            if(message['data']['screen'] == 'MsgBox()')
            {
              print("msgbx");
              print(" Configuration ");
              Navigator.push(context , MaterialPageRoute(builder: (BuildContext context ){
                return MsgBox();
              }));
            }
            else if(message['data']['screen'] == 'Notification')
            {
              controller.animateTo(3);
            }
            else if(message['data']['screen'] == 'Requests')
            {
              controller.animateTo(3);
              Navigator.push(
                  context , MaterialPageRoute(
                  builder: (BuildContext context)
                  {
                    return Requests();
                  }
                )
              );
            }
          });
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  controller: controller,
                  children: <Widget>[
                    NewPosts(),
                    UserEvents(),
                    SearchHere(),
                    Notifications(),
                    MyProfilePage(),
                  ],
                ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                color: Colors.white,
                child: TabBar(
                  controller: controller,
                  indicator:  BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Creates border
                      color: Colors.black.withOpacity(0.4)),
                  indicatorColor: Colors.orangeAccent,
                  tabs: [
                    Container(
                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.home,color:Colors.black,size:30, ),
                          onPressed: () => UserEvents(),
                          // onPressed: () => Navigator.pushNamed(context, '/userEvent'),
                        )
                    ),
                    Container(
                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.event_available,color:Colors.black,size:30, ),
                          onPressed: () => UserEvents(),
                          // onPressed: () => Navigator.pushNamed(context, '/userEvent'),
                        )
                    ),
                    Container(
                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.search,color:Colors.black,size:30, ),
                          onPressed: () => SearchHere(),
                          //onPressed: () => Navigator.pushNamed(context, '/searchHere'),
                        )
                    ),
                    Container(
                        child:IconButton(
                          splashColor: Colors.deepPurple,
                          highlightColor: Colors.deepOrangeAccent,
                          icon : Icon(Icons.notifications,color:Colors.black,size:30, ),
                          onPressed: () => Notifications(),
                          //onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        )
                    ),
                    Container(
                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.person_outline,color:Colors.black,size:30, ),
                          onPressed: () => MyProfilePage(),
                        //  onPressed: () => Navigator.pushNamed(context, '/myProfile'),
                        )
                    ),
                  ],
                ),
              ),
            )
          ],
        ) //NewsFeed()
      ),
    );
  }
}