
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

  void setUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
      print(uid);

      getMyEvents();

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
    Firestore.instance.collection("Ravan").document(uid).collection("Events").getDocuments().then((value){
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
    scrollController.addListener(() => setState(() {}));
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
          centerTitle: true,

          /*title: Text("Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),*/
          background:StreamBuilder(
            stream: Firestore.instance.collection('Ravan')
              .document(uid)
              .snapshots(),
            builder: (context ,snapshot){

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: snapshot.data != null ? Column(
                    children: <Widget>[
                      ConstrainedBox(

                        constraints: BoxConstraints(
                          maxHeight: 400,
                        ),

                        //width: MediaQuery.of(context).size.width,
                        /* */
                        child: Container(


                          decoration: BoxDecoration(

                              color: Color(0xff09203f),

                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xffff512f),
                                    Color(0xffdd2476)
                                  ]
                              )
                          ),
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
                                            fit: BoxFit.contain

                                        ):Container(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2,),
                                snapshot.data != null ?
                                Center(child: Container(color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data['bio'],
                                        style: TextStyle(fontSize: 16),),
                                    )),) : SizedBox(height: 0,width: 0,),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(snapshot.data['name']
                                        , style: TextStyle(
                                            fontSize: 23,
                                            fontFamily: "Pacifico",
                                            color: Colors.white
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
                                          padding: const EdgeInsets.all(8.0),
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
                                              Navigator.pushReplacementNamed(
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
                                            color: Colors.white
                                        ),),
                                        SizedBox(height: 3,)
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                            color: Colors.white
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
                    ],
                  ) : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff48c6ef), Color(0xff6f86d6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                    ),
                  )
                ),
              );
            },
          )

      ),
    );

    return Scaffold(
        endDrawer: StreamBuilder(
            stream: Firestore.instance.collection('Ravan')
                .document(uid)
                .snapshots(),
            builder: (context, snapshot) {
              return Drawer(
                  child: ListView(

                    //padding : EdgeInsets.only(left : 3.0 , right : 3.0),

                    children: <Widget>[
                      DrawerHeader(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff48c6ef), Color(0xff6f86d6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                          ),

                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 5.0,),
                                InkWell(
                                  highlightColor: Colors.orangeAccent,
                                  splashColor: Colors.cyanAccent,
                                  radius: 5.0,

                                  /* onTap: () {
                                  Navigator.pushNamed(context, '/imagePick');
                                  //ImagePick();
                                },*/

                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    child: ClipOval(

                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(

                                            image: CachedNetworkImageProvider(
                                                snapshot.data["image"]),
                                            //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                            fit: BoxFit.contain

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                Text(snapshot.data["name"],
                                    style: TextStyle(
                                        fontSize: 15.0,
//                                        fontFamily: 'Sriracha',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3.0,
                                        color: Colors.white
                                    )
                                )
                              ],
                            ),

                          ),
                        ),
                      ),

                      Divider(
                        color: Colors.blueAccent,
                      ),
                      Container(
                        color: Color(0xff50A6C2),
                        child: InkWell(
                          highlightColor: Colors.orangeAccent,
                          splashColor: Colors.cyanAccent,
                          radius: 5.0,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                              leading: Icon(
                                Icons.event_available,
                                color: Colors.deepPurple,
                              ),
                              title: Text('MyEvents',
                                style: TextStyle(
                                  fontSize: 16.0,
  ///                                fontFamily: 'Sriracha',
                                  color: Colors.white,
                                ),)

                          ),
                        ),
                      ),

                      SizedBox(height: 3,),
                      Container(
                        color: Color(0xff50A6C2),
                        child: InkWell(
                          highlightColor: Colors.orangeAccent,
                          splashColor: Colors.cyanAccent,
                          radius: 5.0,
                          onTap: () {
                            Navigator.pushNamed(context, '/myImages');
                          },
                          child: ListTile(
                              leading: Icon(
                                Icons.image,
                                color: Colors.deepPurple,
                              ),
                              title: Text('Images',
                                style: TextStyle(
                                  fontSize: 16.0,
     //                             fontFamily: 'Sriracha',
                                  color: Colors.white,
                                ),)

                          ),
                        ),
                      ),

                      SizedBox(height: 3),

                      Container(
                        color: Color(0xff50A6C2),
                        child: InkWell(
                          highlightColor: Colors.orangeAccent,
                          splashColor: Colors.cyanAccent,
                          onTap: () {
                            Navigator.of(context).pop();
                          },

                          child: ListTile(
                              leading: Icon(
                                Icons.person_outline,
                                color: Colors.deepPurple,
                              ),
                              title: Text('Friends',
                                style: TextStyle(
       //                           fontFamily: 'Sriracha',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),)
                          ),
                        ),
                      ),

                      SizedBox(height: 3),

                      Container(
                        color: Color(0xff50A6C2),
                        child: InkWell(
                          highlightColor: Colors.orangeAccent,
                          splashColor: Colors.cyanAccent,
                          onTap: () async {
                           // Navigator.pop(context);
                            auth.signOut().then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              //Navigator.pushReplacement(context, 'sig')
                            });
                          },

                          child: ListTile(
                              leading: Icon(
                                Icons.arrow_forward,
                                color: Colors.deepPurple,
                              ),
                              title: Text('LogOut',
                                style: TextStyle(
                                  fontFamily: 'Sriracha',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),)
                          ),
                        ),
                      ),
                      // ignore: missing_return
                    ],
                  )

              );
            }
        ),



         appBar: AppBar(
            elevation: 3.0,
            brightness: Brightness.dark,
            titleSpacing: 2.0,
            title: Text("Profile",
            style : TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff09203f),

      ),

        body: StreamBuilder(
            stream: Firestore.instance.collection('Ravan')
                .document(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              name = snapshot.data["name"];
              print(name);
              profilepic = snapshot.data["image"];
              return SafeArea(
                child: Scaffold(

                  body: new DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: scrollController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          flexibleSpaceWidget,
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                labelColor: Colors.black87,
                                unselectedLabelColor: Colors.black26,
                                tabs: [
                                  Tab(
                                    icon: Icon(Icons.photo_album),
                                    text: "Photos",
                                  ),
                                  Tab(icon: Icon(Icons.event), text: "Events"),
                            //      Tab(icon: Icon(Icons.monetization_on), text: "Earning"),
                                ],
                              ),
                            ),
                           // pinned: true,
                          ),
                        ];
                      },
                      body: new TabBarView(
                        children: <Widget>[
                          new StreamBuilder(
                      stream: Firestore.instance.collection('Ravan').document(uid).collection('MyImages').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Loading();
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
                         Container(decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.centerRight,
                             stops: [0.1 , 0.5],
                             colors: [Colors.pinkAccent ,Colors.deepOrangeAccent]
                           )
                         ),
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
                                     borderRadius: BorderRadius.circular(5)
                                   ),
                                   height: 50,
                                   child: ListTile(
                                     leading: Icon(Icons.event_note ,color: Colors.teal,),
                                     title: Text(myEvents[index]['event_name'] , style: TextStyle(color: Colors.orange ,  fontFamily: 'Sriracha'),
                                     overflow: TextOverflow.ellipsis,),
                                   )
                                 ),
                               ),
                             ) : Center(child: Text(" No Registered Users " , style: TextStyle(color: Colors.white , fontFamily: 'Sriracha' ),),);
                           }
                           ),
                         )// Center(child: new Text("Empty")),
                          //new Text("Earning"),
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

    var increment ,decrement;

      Future<bool> checkLiked()
      async {
        return await Firestore.instance.collection('UserUploadedImages').document(snapshot.documentID).collection('Liked').document(uid).get()
            .then((value) {
          if(!value.exists)
          {
            return false;
          }
          else
          {
            return true;
          }
        });
      }

      void increaseLikes()
      async {

        increment = snapshot.data["likes"] + 1;

        //sendNotification(id , snapshot);

        Firestore.instance.collection('UserUploadedImages').document(snapshot.documentID).
        updateData({'likes' : increment} );

        Firestore.instance.collection('UserUploadedImages').document(snapshot.documentID).collection('Liked').
        document(uid).setData({
          'id' : uid,
        });

      }

      void decreaseLikes()
      async {

        decrement = snapshot.data['likes'] - 1;

        await Firestore.instance.collection('UserUploadedImages').document(snapshot.documentID).collection('Liked')
            .document(uid).delete();

        Firestore.instance.collection('UserUploadedImages').document(snapshot.documentID).
        updateData({'likes' : decrement} );

      }

      return Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 400,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 3, bottom: 3),
            child: Material(

              color: Colors.white,

              shadowColor: Colors.orangeAccent,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: InkWell(
                    onTap: () {
                    },
                    splashColor: Colors.cyanAccent,
                    highlightColor: Colors.teal,

                    child: Column(
                      children: <Widget>[

                        Container(

                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          //height : .0,
                          child: Row(
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 18,
                                  child: ClipOval(
                                    child: SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: Image(

                                          image: CachedNetworkImageProvider(
                                              profilepic),
                                          //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                          fit: BoxFit.contain

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(snapshot['name']
                                      ,style : TextStyle(
                                        fontSize: 17,
                          //              fontFamily: "Pacifico",
                                        //  color: Colors.white
                                      ),),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ),
                        Expanded(
                          child: Container(

                            child: CachedNetworkImage(
                              imageUrl: snapshot.data["image"],
                              imageBuilder: (context , imageProvider) => Container(
                                decoration: BoxDecoration(
                                    image : DecorationImage(
                                      image : imageProvider,
                                      fit : BoxFit.contain,
                                    )
                                ),
                              ),
                              placeholder: (context , url) => Center(child: SpinKitDualRing(color: Colors.deepPurple,size: 60,)),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),

                        Container(
                            decoration: BoxDecoration(
                              /*border: Border.all(
                                        color : Colors.deepPurpleAccent,
                                        width: 3

                                      )*/
                            ),
                          /*  child : Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.thumb_up,
                                    size: 30,
                                    color: Colors.redAccent,
                                  ),

                                  onPressed:(){

                                  },

                                ),

                                IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.add_comment,
                                      color: Colors.blue,
                                      size : 30),
                                ),
                              ],
                            )*/
                        ),
                        SizedBox(height: 1),

                        /*Container(
                          decoration: BoxDecoration(
                            /*border: Border.all(
                                        color : Colors.deepPurpleAccent,
                                        width: 3

                                      )*/
                          ),
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
                                        icon: Icon(Icons.favorite_border,size: 25,),
                                      );
                                    }
                                  }
                              ),
                              IconButton(
                                onPressed: (){

                                  /*showModalBottomSheet(

//                                      backgroundColor: Colors.blue,
                                        enableDrag: true,
                                        context: context,
                                        builder:(context)=> Container(
                                          height: MediaQuery.of(context).size.height/2,
                                          width: MediaQuery.of(context).size.width,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: TextField(
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                filled: true,
                                                focusColor: Colors.purple,
                                                hoverColor: Colors.red,
                                                hintText: "Comment",
                                                fillColor: Colors.white,

                                                border : OutlineInputBorder(),


                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                    borderSide: BorderSide(color: Colors.blueGrey,width: 2)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                                                ),
                                              ),
                                              onChanged : (val) {
                                                //msg = val;
                                              },

                                              onSubmitted: (String str){
                                                //myController.clear();
                                              },


                                            ),
                                          ),
                                        )

                                    );*/
                                },
                                icon: Icon(Icons.add_comment,
                                    color: Colors.deepPurple,
                                    size : 30),
                              ),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal : 8.0 ,vertical: 1),
                              child: Text("Hearts"
                                ,style : TextStyle(
                                    fontSize: 20,
                                    //              fontWeight: FontWeight.bold,
                                    //     fontFamily: "Piedra",
                                    color: Colors.indigo
                                ),),
                            ),
                            SizedBox(width:2),
                            Text(snapshot.data["likes"].toString(),
                              style : TextStyle(
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold,
                                  //fontFamily: "Piedra",
                                  color: Colors.indigo
                              ),),
                          ],
                        ),*/

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
























