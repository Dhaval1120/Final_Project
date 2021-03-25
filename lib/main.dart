import 'package:flutter/material.dart';
import 'package:obvio/Home/ChatBox.dart';
import 'package:obvio/Home/EditProfile.dart';
import 'package:obvio/Home/Followers.dart';
import 'package:obvio/Home/Following.dart';
import 'package:obvio/Home/ListedUsers.dart';
import 'package:obvio/Home/MsgBox.dart';
import 'package:obvio/Home/MyImages.dart';
import 'package:obvio/Home/MyProfile.dart';
import 'package:obvio/Home/Requests.dart';
import 'package:obvio/Home/SearchHere.dart';
import 'package:obvio/Home/SearchedUser.dart';
import 'package:obvio/Home/UplaodImage.dart';
import 'package:obvio/Home/UserEvents.dart';
import 'package:obvio/Home/addEvent.dart';
import 'package:obvio/Home/imagepicker.dart';
import 'package:obvio/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:obvio/Services/auth.dart';
import 'package:obvio/Model/user.dart';
import 'package:obvio/Home/Notifications.dart';
import 'package:obvio/Authenticate/Register.dart';
import 'package:obvio/Home/EventDescription.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value : AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor : Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes : {
          //'/signUp' : (context) => Register(),
          '/eventDescription' : (context) => EventDesc(),
          '/imagePick' : (context) => ImagePick(),
          '/addEvent' : (context) => AddEvent(),
          '/userEvent' : (context) => UserEvents(),
          '/myProfile' : (context) => MyProfilePage(),
          '/uploadMyImage' : (context) => UploadMyImage(),
          '/myImages' : (context) => MyImages(),
          '/searchHere' : (context) => SearchHere(),
          '/listedUsers' : (context) =>ListedUsers(),
          '/searchedUser' : (context) => SearchedUser(),
          '/notifications' : (context)=> Notifications(),
          '/requests' : (context) => Requests(),
          '/followers': (context) => Followers(),
          '/following':(context) => Following(),
          '/chatbox' : (context) => ChatBox(),
          '/msgbox' : (context) => MsgBox(),
          '/editProfile' : (context) => EditProfile(),
        },
      ),
    );
  }
}

