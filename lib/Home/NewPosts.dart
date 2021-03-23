import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Home/MyProfile.dart';
import 'package:obvio/Home/addComment.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewPosts extends StatefulWidget {
  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  final AuthService auth = AuthService();
  var name;
  var currentUser;
  TransformationController controller = TransformationController();
  String currentId = '' , currentProfile = '';

  var profilePic = "";
  Future<void> sendNotification (var id , DocumentSnapshot snapshot)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
   // var email = snapshot.data['email'];

   var docId = snapshot.data["docId"];
    Firestore.instance.collection('Ravan').document(docId).collection('Notifications').add({
      'name' : currentUser,
      'email' : user.email,
      'imageId' : docId,
      'userId' : currentId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'profilepic' : currentProfile,
    });

  }

  void setName()
   async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
     setState(() {
       currentId = user.uid;
       Firestore.instance.collection('Ravan').document(currentId).get().then((value) => {
        currentUser = value["name"],
         currentProfile = value["image"],
        //print(currentProfile),
      });
    });

  }

  void initState(){
    super.initState();
    setName();
  }
  
  var docId ;


  Widget _buildNewPosts(BuildContext context, DocumentSnapshot snapshot, int index ,int length) {
    TransformationController controller = TransformationController();
    var id = snapshot.documentID;
    var increment , decrement;
    int totalLikes = 0;
    bool isLiked = false;

    var icon;
    
    Future<bool> checkLiked()
    async {
      var docs = await Firestore.instance.collection('Ravan').document(currentId).collection("NewsFeed").document(snapshot.documentID).collection("Likes").getDocuments();
      setState(() {
        totalLikes = docs.documents.length;
      });
      for(int i = 0 ; i < docs.documents.length ; i++)
        {
          if(docs.documents.elementAt(i)['userId'] == currentId)
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

    void increaseLikes()
    async {
      print(" document is ${snapshot.documentID}");
      Firestore.instance.collection('Ravan').document(currentId).collection("NewsFeed").document(snapshot.documentID).collection("Likes").document(currentId).setData({
        "userId": currentId
      });
    setState(() {
       isLiked = true;
    });
    }

    void decreaseLikes()
    async {
      print(" decresing ");
       Firestore.instance.collection('Ravan').document(currentId).collection("NewsFeed").document(snapshot.documentID).collection("Likes").document(currentId).delete();
       setState(() {
         isLiked = false;
       });
      }
    docId = snapshot['docId'];
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
                                          onTap: (){
                                            if(snapshot['docId'] == currentId)
                                              {
                                                Navigator.pushNamed(context, '/myProfile');
                                              }
                                            else
                                              {
                                                Navigator.pushNamed(context, '/searchedUser' ,arguments: {
                                                  'id' : snapshot['docId'],
                                                  'name' : snapshot.data['name'],
                                                });

                                              }
                                            },
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
                              decoration: BoxDecoration(
                                ),
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
                                        fit : BoxFit.contain,
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
                                          onPressed: (){
                                            increaseLikes();
                                          },
                                          icon: Icon(Icons.favorite_border,size: 25,),
                                        );
                                      }
                                    }
                                ),
                                IconButton(
                                  onPressed: (){
                                  //   Navigator.push(context, MaterialPageRoute(
                                  //     builder: (BuildContext context)
                                  //         {
                                  //           return AddComment(commnentId: snapshot.documentID,);
                                  //         }
                                  //   ));
                                   },
                                  icon: Icon(Icons.add_comment,
                                      color: Colors.blueGrey,
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
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal : 8.0 ,vertical: 1),
                      //         child: Text("Hearts"
                      //           ,style : TextStyle(
                      //               fontSize: 20,
                      // //              fontWeight: FontWeight.bold,
                      //          //     fontFamily: "Piedra",
                      //               color: Colors.indigo
                      //           ),),
                      //       ),
                      //       SizedBox(width:2),
                      //       Text("1",
                      //         style : TextStyle(
                      //             fontSize: 20,
                      //             //fontWeight: FontWeight.bold,
                      //             //fontFamily: "Piedra",
                      //             color: Colors.indigo
                      //         ),),
                      //     ],
                      //   ),


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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Material(
            color: Colors.red,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffff512f),Color(0xffdd2476)],
                )
              ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(

                        child:IconButton(

                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.event_available,color:Colors.white,size:30, ),
                          onPressed: () => Navigator.pushNamed(context, '/userEvent'),
                        )
                    ),

                    Container(
                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.search,color:Colors.white,size:30, ),
                          onPressed: () => Navigator.pushNamed(context, '/searchHere'),
                        )
                    ),
                    Container(
                        child:IconButton(
                          splashColor: Colors.deepPurple,
                          highlightColor: Colors.deepOrangeAccent,
                          icon : Icon(Icons.notifications,color:Colors.white,size:30, ),
                          onPressed: () => Navigator.pushNamed(context, '/notifications'),
                        )
                    ),
                    Container(


                        child:IconButton(
                          highlightColor: Colors.deepOrangeAccent,
                          splashColor: Colors.deepPurple,
                          icon : Icon(Icons.person_outline,color:Colors.white,size:30, ),
                          onPressed: () => Navigator.pushNamed(context, '/myProfile'),

                        )
                    ),

                  ],
                )
            ),
          ),

          //drawer: openDrawer(),
        body :
        Stack(
          children: <Widget>[
            StreamBuilder(
                       stream: Firestore.instance.collection("Ravan").document(currentId).collection("NewsFeed").orderBy('timestamp' , descending: true).snapshots(),
                       builder: (context, snapshot) {
                          if (!snapshot.hasData) return Loading();
                          else if(snapshot.data.documents.length < 1){
                            return Center(
                              child: Text("No Images to Show" , style: TextStyle(
                                //  color: Colors.blue,
                                  fontSize: 22,
                                  //fontFamily: 'Pacifico'
                              ),),
                            );
                          }


                          return ListView.builder(
                            itemBuilder: (context, index) =>
                             _buildNewPosts(
                            context, snapshot.data.documents[index] , index , snapshot.data.documents.length),
                            itemCount: snapshot.data.documents.length,
                    //              itemExtent: 80.0,
                  );
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: InkWell(
              onTap: () => {
                Navigator.pushNamed(context , '/uploadMyImage' )},
                child: Icon(
                Icons.add,
                size: 35,
              ),
            )
        ),
      ),
    );
  }
}

