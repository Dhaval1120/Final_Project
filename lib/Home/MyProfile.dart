
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:obvio/Home/registeredUsers.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:obvio/Services/auth.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import 'addComment.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>  {

  String uid = '';
  var followers = "",
      following = "";
  final picker = ImagePicker();
  String url;
  List registeredEvents = List();
  List registeredEventsDocIds = List();
  getRegisteredEvents() async{
    Firestore.instance.collection("Ravan").document(uid).collection("RegisteredEvents").orderBy("timeStamp" , descending: true).getDocuments().then((value) {
       //registeredEvents.add(value);
       for(int i = 0; i < value.documents.length ; i++)
         {
           registeredEventsDocIds.add(value.documents[i]['eventId']);
           print(" Added Value is ${value.documents[i].documentID}");
           Firestore.instance.collection("EventDetails").document(value.documents[i]['eventId']).get().then((value) {
              registeredEvents.add(value);
              setState(() {
              });
           });
         }
    });
  }
  void setUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
      print(uid);
      getMyEvents();
      getRegisteredEvents();
      Firestore.instance.collection('Ravan').document(uid).collection(
          "Followers").getDocuments().then((value) {
            setState(() {
              followers = value.documents.length.toString();
            });
      });
      Firestore.instance.collection('Ravan').document(uid).collection(
          'Following').getDocuments().then((value) {
           setState(() {
             following = value.documents.length.toString();
           });
      });
    });
  }
  List myEvents = List();
  List eventsDocIds = List();
  getMyEvents()async{
    int i = 0;
    Firestore.instance.collection("Ravan").document(uid).collection("Events").orderBy("timeStamp" , descending: true).getDocuments().then((value){
      value.documents.forEach((element) {
        setState(() {
          myEvents.add(element);
          eventsDocIds.add(element.documentID);
          print(" ID is ${element.documentID}");
          });
        i++;
      });
    });
    // Firestore.instance.collection("Ravan").document(uid).collection("Events").getDocuments().then((value){
    //   print(" get My ");
    //    value.documents.forEach((element) {
    //      setState(() {
    //        print(element['about']);
    //        myEvents.add(element);
    //      });
    //    });
    // }).then((value) {
    //   print(' Events are $myEvents');
    // });
  }

  ScrollController scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
    scrollController = new ScrollController();
   // scrollController.addListener(() => setState(() {}));
  }

  var name;
  var profilepic;

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);


    var flexibleSpaceWidget = new SliverAppBar(
      leading: Container(),
      expandedHeight: 400.0,
      pinned: false,
     // floating: true,
      flexibleSpace: FlexibleSpaceBar(
          background:StreamBuilder(
            stream: Firestore.instance.collection('Ravan')
              .document(uid)
              .snapshots(),
            builder: (context ,snapshot){
              return SingleChildScrollView(
                child: snapshot.data != null ? Column(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                       // maxHeight: 400,
                      ),
                      child: Expanded(
                        child: Container(
                          //height: double.infinity,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 100,
                                  child: ClipOval(
                                    child: SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(),
                                        child: InkWell(
                                          onLongPress: () =>
                                              showDialog(context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: RaisedButton(
                                                        focusColor: Colors
                                                            .redAccent,
                                                        color: Colors.redAccent,
                                                        child: Text(
                                                          "Upload Profile Picture",
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,

                                                          ),),
                                                        onPressed: () =>
                                                            Navigator
                                                                .pushReplacementNamed(
                                                                context,
                                                                '/imagePick'),
                                                      ),
                                                    );
                                                  }
                                              ),
                                          child: snapshot.data != null ? Image(
                                              image: CachedNetworkImageProvider(
                                                  snapshot.data["image"]),
                                              //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                              fit: BoxFit.cover
                                          ):Container(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                snapshot.data != null ?
                                Center(child: Container(color: Colors.black12,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:snapshot.data['bio'] != null ? Text(snapshot.data['bio'],
                                        style: TextStyle(fontSize: 16),) : SizedBox(height: 0,width: 0,)
                                    )),) : SizedBox(height: 0,width: 0,),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(snapshot.data['name']
                                        , style: TextStyle(
                                            fontSize: 18,
                                          //  fontFamily: "Pacifico",
                                            color: Colors.black,
                                        ),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: RaisedButton(
                                            color: Colors.blueAccent,
                                            child: Text(
                                              "Followers", style: TextStyle(
                                                fontSize: 20,
                                                // fontFamily: 'Pacifico',
                                                color: Colors.white

                                            ),),
                                            onPressed: () =>
                                            {
                                              Navigator.pushNamed(
                                                  context, '/followers',
                                                  arguments: {
                                                    'id': uid,
                                                  })
                                            },
                                          ),
                                        ),
                                        Text(followers, style: TextStyle(
                                            fontSize: 20,
                                            // fontFamily: 'Pacifico',
                                            color: Colors.red
                                        ),),
                                        SizedBox(height: 3,)
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: RaisedButton(
                                            color: Colors.blueAccent,
                                            child: Text(
                                              "Following", style: TextStyle(
                                                fontSize: 20,
                                                // fontFamily: 'Pacifico',
                                                color: Colors.white

                                            ),),
                                            onPressed: () =>
                                            {
                                              Navigator.pushNamed(
                                                  context, '/following',
                                                  arguments: {
                                                    'id': uid,
                                                  })
                                            },

                                          ),
                                        ),
                                        Text(following, style: TextStyle(
                                            fontSize: 20,
                                            // fontFamily: 'Pacifico',
                                            color: Colors.red
                                        ),),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 3,
                                ),

                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  elevation: 10,
                                  color: Color(0xff6495ed),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "Edit Profile", style: TextStyle(
                                        fontSize: 18,
                                        //fontFamily: 'Pacifico',
                                        color: Colors.white

                                    ),),
                                  ),
                                  onPressed: () =>
                                  {
                                    Navigator.pushNamed(
                                        context, '/editProfile'),
                                  },
                                ),
                                SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ) : Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff48c6ef), Color(0xff6f86d6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                  ),
                ),
              );
            },
          )

      ),
    );

    return Scaffold(
//         endDrawer: StreamBuilder(
//             stream: Firestore.instance.collection('Ravan')
//                 .document(uid)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               return Drawer(
//                   child: ListView(
//
//                     //padding : EdgeInsets.only(left : 3.0 , right : 3.0),
//
//                     children: <Widget>[
//                       DrawerHeader(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xff48c6ef), Color(0xff6f86d6)],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               )
//                           ),
//
//                           child: Center(
//                             child: Column(
//                               children: <Widget>[
//                                 SizedBox(height: 5.0,),
//                                 InkWell(
//                                   highlightColor: Colors.orangeAccent,
//                                   splashColor: Colors.cyanAccent,
//                                   radius: 5.0,
//
//                                   /* onTap: () {
//                                   Navigator.pushNamed(context, '/imagePick');
//                                   //ImagePick();
//                                 },*/
//
//                                   child: CircleAvatar(
//                                     backgroundColor: Colors.white,
//                                     radius: 50,
//                                     child: ClipOval(
//
//                                       child: SizedBox(
//                                         height: 100,
//                                         width: 100,
//                                         child: Image(
//
//                                             image: CachedNetworkImageProvider(
//                                                 snapshot.data["image"]),
//                                             //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
//                                             fit: BoxFit.contain
//
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 1),
//                                 Text(snapshot.data["name"],
//                                     style: TextStyle(
//                                         fontSize: 15.0,
// //                                        fontFamily: 'Sriracha',
//                                         fontWeight: FontWeight.bold,
//                                         letterSpacing: 3.0,
//                                         color: Colors.white
//                                     )
//                                 )
//                               ],
//                             ),
//
//                           ),
//                         ),
//                       ),
//
//                       Divider(
//                         color: Colors.blueAccent,
//                       ),
//                       Container(
//                         color: Color(0xff50A6C2),
//                         child: InkWell(
//                           highlightColor: Colors.orangeAccent,
//                           splashColor: Colors.cyanAccent,
//                           radius: 5.0,
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: ListTile(
//                               leading: Icon(
//                                 Icons.event_available,
//                                 color: Colors.deepPurple,
//                               ),
//                               title: Text('MyEvents',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//   ///                                fontFamily: 'Sriracha',
//                                   color: Colors.white,
//                                 ),)
//
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: 3,),
//                       Container(
//                         color: Color(0xff50A6C2),
//                         child: InkWell(
//                           highlightColor: Colors.orangeAccent,
//                           splashColor: Colors.cyanAccent,
//                           radius: 5.0,
//                           onTap: () {
//                             Navigator.pushNamed(context, '/myImages');
//                           },
//                           child: ListTile(
//                               leading: Icon(
//                                 Icons.image,
//                                 color: Colors.deepPurple,
//                               ),
//                               title: Text('Images',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//      //                             fontFamily: 'Sriracha',
//                                   color: Colors.white,
//                                 ),)
//
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: 3),
//
//                       Container(
//                         color: Color(0xff50A6C2),
//                         child: InkWell(
//                           highlightColor: Colors.orangeAccent,
//                           splashColor: Colors.cyanAccent,
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//
//                           child: ListTile(
//                               leading: Icon(
//                                 Icons.person_outline,
//                                 color: Colors.deepPurple,
//                               ),
//                               title: Text('Friends',
//                                 style: TextStyle(
//        //                           fontFamily: 'Sriracha',
//                                   fontSize: 16.0,
//                                   color: Colors.white,
//                                 ),)
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: 3),
//
//                       Container(
//                         color: Color(0xff50A6C2),
//                         child: InkWell(
//                           highlightColor: Colors.orangeAccent,
//                           splashColor: Colors.cyanAccent,
//                           onTap: () async {
//                            // Navigator.pop(context);
//                             auth.signOut().then((value) {
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                               //Navigator.pushReplacement(context, 'sig')
//                             });
//                           },
//
//                           child: ListTile(
//                               leading: Icon(
//                                 Icons.arrow_forward,
//                                 color: Colors.deepPurple,
//                               ),
//                               title: Text('LogOut',
//                                 style: TextStyle(
//                                   fontFamily: 'Sriracha',
//                                   fontSize: 16.0,
//                                   color: Colors.white,
//                                 ),)
//                           ),
//                         ),
//                       ),
//                       // ignore: missing_return
//                     ],
//                   )
//
//               );
//             }
//         ),
//       //   appBar: AppBar(
      //       elevation: 3.0,
      //       brightness: Brightness.dark,
      //       titleSpacing: 2.0,
      //       title: Text("Profile",
      //       style : TextStyle(
      //       fontFamily: 'Pacifico',
      //       fontSize: 20.0,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Color(0xff09203f),
      // ),

        body: StreamBuilder(
            stream: Firestore.instance.collection('Ravan')
                .document(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              name = snapshot.data["name"];
              print(name);
              profilepic = snapshot.data["image"];
              return SafeArea(
                child: Scaffold(
                  body: new DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                      controller: scrollController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverToBoxAdapter(
                            child:   ClipRRect(
                                child: Material(
                                  elevation: 20,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [Colors.deepOrangeAccent , Colors.orange]
                                          )
                                      ),
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListTile(
                                          title: Text(" Profile ", style:  TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            //fontFamily: "Lobster"
                                          ),),
                                        trailing: InkWell(
                                          child: Container(
                                                child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Log Out" ,style: TextStyle(color: Colors.white),),
                                          ),
                                          color: Colors.black12,),
                                          onTap: (){
                                            auth.signOut().then((value) {
                                            });
                                          },
                                        ),
                                      )
                                    //color: Colors.redAccent
                                  ),
                                ),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: 5,),
                          ),
                          flexibleSpaceWidget,
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                labelColor: Colors.redAccent,
                                indicatorColor: Colors.deepPurple,
                                unselectedLabelColor: Colors.black26,
                                tabs: [
                                  Tab(child: Image.asset('assets/photos_icon.png',height: 40 ,width: 40,), ),
                                  Tab(child: Image.asset('assets/event_icon.png',height: 40 ,width: 40),),
                                  Tab(child: Image.asset('assets/registered_event_icon.png',height: 40 ,width: 40),),
                                ],
                              ),
                            ),
                           // pinned: true,
                          ),
                        ];
                      },
                      body: new TabBarView(
                        children: <Widget>[
                          // Images
                          new StreamBuilder(
                          stream: Firestore.instance.collection('Ravan').document(uid).collection('MyImages').snapshots(),
                           builder: (context, snapshot) {
                           if (!snapshot.hasData) return Container();
                            else if(snapshot.data.documents.length < 1){
                             return Center(
                               child: Text("No Images to Show" , style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 22,
                                  fontFamily: 'Pacifico'
                              ),),
                            );
                          }
                          return ListView.builder(
                              itemBuilder: (context, index) =>
                                  _buildMyImages(
                                      context, snapshot.data.documents[index]),
                              itemCount: snapshot.data.documents.length,
                              //              itemExtent: 80.0,
                            );

                          }
                        ),
                         // Events
                         myEvents.length != 0 ?  Container(decoration: BoxDecoration(),
                           child: ListView.builder(
                               itemCount: myEvents.length,
                               itemBuilder: (BuildContext context, int index) {
                                 return myEvents.length != 0 ? InkWell(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                       return RegisteredUsers(docId: eventsDocIds[index]);
                                     }));
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Container(
                                         decoration: BoxDecoration(
                                             color: Color(0xfff0fff0),
                                             border: Border.all(color: Colors.black),
                                             borderRadius: BorderRadius.circular(5)
                                         ),
                                         height: 50,
                                         child: ListTile(
                                           //  tileColor: ,
                                           leading: Icon(Icons.event_note ,color: Colors.teal,),
                                           title: Text(myEvents[index]['event_name'] , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                             overflow: TextOverflow.ellipsis,),
                                         )
                                     ),
                                   ),
                                 ) : Container(
                                 );//Center(child: Text(" No Registered Users " , style: TextStyle(color: Colors.white , fontFamily: 'Sriracha' ),),);
                               }
                           ),
                         ) : Center(child: Container(child: Text(" No Events "),),),// Center(child: new Text("Empty")),
                          // Registered Events
                          Center(child: registeredEvents.length != 0 ? ListView.builder(
                            itemBuilder: (BuildContext context , int index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff0fff0),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  height: 50,
                                  child: ListTile(
                                    leading: Icon(Icons.event_available , color: Colors.lightGreen,),
                                    onTap: (){
                                      Navigator.pushNamed(context, '/eventDescription', arguments: {
                                        'event_id' : registeredEventsDocIds[index],
                                        'isRegistered' : true
                                      }
                                      );
                                    },
                                    title: Text(registeredEvents[index]['event_name'].toString(), overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            },itemCount: registeredEvents.length,) : Center(child: Container(child : Text(" No Events "))))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }


    Widget _buildMyImages(BuildContext context, DocumentSnapshot snapshot) {
      TransformationController controller = TransformationController();
      var id = snapshot.documentID;
      var increment , decrement;
      bool isLiked = false;
      int likes = 0;
      var icon;
      Future<bool> checkLiked()
      async {
        var docs = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").getDocuments();
        for(int i = 0 ; i < docs.documents.length ; i++)
        {
          if(docs.documents.elementAt(i)['userId'] == uid)
          {
            return true;
          }
        }
        return false;
      }

      Future<String> getProfile()
      async {
        return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);
      }

      Future<int> getLikes() async{
        DocumentSnapshot documentSnapshot = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get();
        return documentSnapshot.data['likes'];
      }
      void increaseLikes()
      async {
        print(" document is ${snapshot.documentID}");
        Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(uid).setData({
          "userId": uid
        });
        Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get().then((likesData) {
          print(" Likes is ${likesData['likes']}");
          int x = likesData['likes'] + 1;
          setState(() {
            likes = x;
            print(" Total Likes $x");
          });
          Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).updateData({
            "likes" : x
          });
        });
        setState(() {
          isLiked = true;
        });
      }
      void decreaseLikes()
      async {
        print(" decresing ");
        Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(uid).delete();
        Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get().then((likesData) {
          int x = likesData['likes']  - 1;
          setState(() {
            likes = x;
            print(" Total Likes $x");
          });
          Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).updateData({
            "likes" : x
          });
        });
        setState(() {
          isLiked = false;
        });
      }
      //docId = snapshot['docId'];
      name = snapshot.data["name"];
   return Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Material(
              color: Colors.white,
              shadowColor: Colors.orangeAccent,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: InkWell(
                    splashColor: Colors.cyanAccent,
                    highlightColor: Colors.pink,
                    child: Column(
                      children: <Widget>[

                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Row(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal : 6.0 ,vertical : 5),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20,
                                        child:
                                        FutureBuilder(
                                            future: getProfile(),
                                            builder:(context ,AsyncSnapshot<String> snapshot) {
                                              if(snapshot.hasData)
                                              {
                                                return ClipOval(
                                                  child: SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: Image(
                                                        image: CachedNetworkImageProvider(snapshot.data),
                                                        //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                                        fit: BoxFit.contain
                                                    ),
                                                  ),
                                                );
                                              }
                                              else
                                              {
                                                return CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 20,
                                                );
                                              }
                                            }
                                        )
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: (){},
                                          child: Text(snapshot.data['name'],style : TextStyle(
                                            fontSize: 18,
                                            //        fontWeight: FontWeight.bold,
                                            // fontFamily: "Pacifico",
                                            //  color: Colors.white
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            //    height: 300.0,
                            child: Container(
                              decoration: BoxDecoration(),
                              child: InteractiveViewer(
                                transformationController: controller,
                                onInteractionEnd: (ScaleEndDetails endDetails){
                                  controller.value = Matrix4.identity();
                                },
                                child: CachedNetworkImage(
                                  imageUrl: snapshot["image"],
                                  imageBuilder: (context , imageProvider) => Container(
                                    decoration: BoxDecoration(
                                        image : DecorationImage(
                                          image : imageProvider,
                                          fit : BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  placeholder: (context , url) => Center(child: SpinKitCubeGrid(color: Colors.indigo,size: 60,)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1),
                        Container(
                          decoration: BoxDecoration(),
                          child : Row(
                            children: <Widget>[
                              FutureBuilder(
                                  future: checkLiked(),
                                  builder:(context ,AsyncSnapshot<bool> snapshot) {
                                    if(snapshot.hasData)
                                    {
                                      if(snapshot.data == false)
                                      {
                                        return IconButton(
                                          onPressed: (){
                                            increaseLikes();
                                          },
                                          icon: Icon(Icons.favorite_border,size: 25,),
                                        );
                                      }
                                      else
                                      {
                                        return  IconButton(
                                          onPressed: (){
                                            decreaseLikes();
                                          },
                                          icon: Icon(Icons.favorite,size: 25,color: Colors.redAccent,),
                                        );
                                      }
                                    }
                                    else
                                    {
                                      return IconButton(
                                        onPressed: (){
                                          increaseLikes();
                                        },
                                        icon: Icon(Icons.favorite_border,size: 25,),
                                      );
                                    }
                                  }
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context)
                                      {
                                        return AddComment(commentId: snapshot.documentID , imageUserId: snapshot['docId'],);
                                      }
                                  ));
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image(
                                    image: AssetImage('assets/comment_icon.jpg'),
                                  ),
                                ),
                              ),
                              FutureBuilder(future : getLikes() ,builder: (BuildContext context , AsyncSnapshot snapshot ){
                                return Text(" Likes ${snapshot.data}");
                              })
                              /*
                                IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.comment,
                                      color: Colors.orangeAccent,
                                      size : 30),
                                ),
                                                    */
                            ],
                          ),
                        ),
                        SizedBox(height: 3,),
                        //Text(totalLikes.toString())
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
