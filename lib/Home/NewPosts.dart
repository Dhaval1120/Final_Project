// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:obvio/Home/MsgBox.dart';
// import 'package:obvio/Home/SearchedUser.dart';
// import 'package:obvio/Home/addComment.dart';
// import 'package:obvio/Services/auth.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:obvio/Notification/notifications.dart';
// import 'package:obvio/Utils/TimeConversion.dart';
// class NewPosts extends StatefulWidget {
//   @override
//   _NewPostsState createState() => _NewPostsState();
// }
//
// class _NewPostsState extends State<NewPosts> {
//   final AuthService auth = AuthService();
//   var name;
//   String currentUser = '';
//   int totalLikes = 0;
//   List posts = List();
//   TransformationController controller = TransformationController();
//   String currentId = '' , currentProfile = '';
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//   var profilePic = "";
//   Future<void> sendNotification (var id , DocumentSnapshot snapshot)async{
//     String token = '';
//     Firestore.instance.collection("Ravan").document(snapshot.data['docId']).get().then((value){
//       token = value['token'];
//       print(" Token is $token ");
//       sendAndRetrieveMessage(token, currentUser.toString() + " liked your photo.", "" , imgUrl: currentProfile);
//     });
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     var docId = snapshot.data["docId"];
//     Firestore.instance.collection('Ravan').document(docId).collection('Notifications').add({
//       'name' : currentUser,
//       'email' : user.email,
//       'imageId' : docId,
//       'userId' : currentId,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'profilepic' : currentProfile,
//       'type' : "like",
//       'imgUrl' : snapshot['image']
//     });
//   }
//
//   void setName()
//   async{
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     setState(() {
//       currentId = user.uid;
//       print("Id is $currentId");
//       getPosts();
//       Firestore.instance.collection('Ravan').document(currentId).get().then((value) => {
//         currentUser = value["name"],
//         currentProfile = value["image"],
//         //print(currentProfile),
//         Firestore.instance.collection('Ravan').document(currentId).get().then((value) async{
//           print("token is ${value['token']}");
//         })
//       });
//     });
//   }
//   getToken() async {
//     String token = await firebaseMessaging.getToken();
//     if(token != null)
//     {
//       Firestore.instance.collection('Ravan').document(currentId).updateData({
//         "token" : token
//       });
//     }
//     Firestore.instance.collection('Ravan').document(currentId).get().then((value) async{
//       print("token is ${value['token']}");
//       // Map<String , dynamic> response =  await sendAndRetrieveMessage(value['token'], "Hii Buddy", "How Are You");
//       // print(" Response is ${response}");
//     });
//   }
//   getPosts() async{
//     Firestore.instance.collection("Ravan").document(currentId).collection("NewsFeed").orderBy('timestamp' , descending: true).getDocuments().then((value) {
//       value.documents.forEach((element) {
//         setState(() {
//           posts.add(element);
//         });
//       });
//     });
//   }
//   void initState(){
//     super.initState();
//     setName();
//     getToken();
//     // firebaseMessaging.configure(
//     //   onMessage: (message ) async{
//     //     print("Message ${message['notification']['title']}");
//     //     return Scaffold.of(context).showSnackBar(SnackBar(content: message["notification"]["title"] , duration: Duration(seconds: 3),));
//     //   },
//     //   onResume: (message) async {
//     //     Scaffold.of(context).showSnackBar(SnackBar(content: message["notification"]["title"],duration: Duration(seconds: 3),));
//     //   }
//     // );
//   }
//
//   var docId ;
//
//   Widget _buildNewPosts(BuildContext context, DocumentSnapshot snapshot, int index ,int length) {
//     TransformationController controller = TransformationController();
//     String timeToDisplay = TimeConvert(snapshot['timestamp']);
//     var id = snapshot.documentID;
//     var increment , decrement;
//     bool isLiked = false;
//     int likes = 0;
//     var icon;
//     //
//     Future<bool> checkLiked()
//     async {
//       var docs = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").getDocuments();
//       setState(() {
//         totalLikes = docs.documents.length;
//       });
//       for(int i = 0 ; i < docs.documents.length ; i++)
//       {
//         if(docs.documents.elementAt(i)['userId'] == currentId)
//         {
//           return true;
//         }
//       }
//       return false;
//     }
//
//     Future<String> getProfile()
//     async {
//       return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);
//     }
//
//     Future<String> getProfileName()
//     async {
//       return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['name']);
//     }
//     Future<int> getLikes() async{
//       DocumentSnapshot documentSnapshot = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get();
//       return documentSnapshot.data['likes'];
//     }
//     void increaseLikes()
//     async {
//       Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(currentId).setData({
//         "userId": currentId
//       });
//       Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get().then((likesData) {
//         print(" Likes is ${likesData['likes']}");
//         int x = likesData['likes'] + 1;
//         setState(() {
//           likes = x;
//           print(" Total Likes $x");
//         });
//         Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).updateData({
//           "likes" : x
//         });
//       });
//       setState(() {
//         isLiked = true;
//       });
//     }
//     void decreaseLikes()
//     async {
//       Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(currentId).delete();
//       Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get().then((likesData) {
//         int x = likesData['likes']  - 1;
//         setState(() {
//           likes = x;
//           print(" Total Likes $x");
//         });
//         Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).updateData({
//           "likes" : x
//         });
//       });
//       setState(() {
//         isLiked = false;
//       });
//     }
//     docId = snapshot['docId'];
//     name = snapshot.data["name"];
//     return Stack(
//       children: <Widget>[
//         ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: 500,
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(top: 4, bottom: 2),
//             child: Material(
//               color: Colors.white,
//               shadowColor: Colors.orangeAccent,
//               child: Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(1),
//                   child: InkWell(
//                     splashColor: Colors.cyanAccent,
//                     highlightColor: Colors.pink,
//                     child: Column(
//                       children: <Widget>[
//
//                         Container(
//                           width: MediaQuery
//                               .of(context)
//                               .size
//                               .width,
//                           child: Row(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal : 6.0 ,vertical : 5),
//                                     child: CircleAvatar(
//                                         backgroundColor: Colors.white,
//                                         radius: 20,
//                                         child:
//                                         FutureBuilder(
//                                             future: getProfile(),
//                                             builder:(context ,AsyncSnapshot<String> snapshot) {
//                                               if(snapshot.hasData)
//                                               {
//                                                 return ClipOval(
//                                                   child: SizedBox(
//                                                     height: 40,
//                                                     width: 40,
//                                                     child: Image(
//                                                         image: CachedNetworkImageProvider(snapshot.data),
//                                                         //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
//                                                         fit: BoxFit.cover
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                               else
//                                               {
//                                                 return CircleAvatar(
//                                                   backgroundColor: Colors.white,
//                                                   radius: 20,
//                                                 );
//                                               }
//                                             }
//                                         )
//                                     ),
//                                   ),
//                                   Column(
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 5 ,vertical: 3),
//                                         child: InkWell(
//                                             onTap: (){
//                                               if(snapshot['docId'] == currentId)
//                                               {
//                                                 Navigator.pushNamed(context, '/myProfile');
//                                               }
//                                               else
//                                               {
//                                                 Navigator.push(
//                                                     context , MaterialPageRoute(builder: (BuildContext context){
//                                                   return SearchedUser(searchedId: snapshot['docId'], name: snapshot.data['name'],);
//                                                 })
//                                                 );
//                                                 // Navigator.pushNamed(context, '/searchedUser' ,arguments: {
//                                                 //   'id' : snapshot['docId'],
//                                                 //   'name' : snapshot.data['name'],
//                                                 // });
//                                               }
//                                             },
//                                             child: Text(snapshot.data['name'])
//                                         ),
//                                       ),
//                                       Text(TimeConvert(snapshot['timestamp']),style: TextStyle(
//                                           color: Colors.black38
//                                       ),)
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         Expanded(
//                           child: Container(
//                             width: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .width,
//                             //    height: 300.0,
//                             child: Container(
//                               decoration: BoxDecoration(),
//                               child: InteractiveViewer(
//                                 transformationController: controller,
//                                 onInteractionEnd: (ScaleEndDetails endDetails){
//                                   controller.value = Matrix4.identity();
//                                 },
//                                 child: CachedNetworkImage(
//                                   imageUrl: snapshot["image"],
//                                   imageBuilder: (context , imageProvider) => Container(
//                                     decoration: BoxDecoration(
//                                         image : DecorationImage(
//                                           image : imageProvider,
//                                           fit : BoxFit.cover,
//                                         )
//                                     ),
//                                   ),
//                                   placeholder: (context , url) => Center(child: SpinKitCubeGrid(color: Colors.indigo,size: 60,)),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 1),
//                         Container(
//                           decoration: BoxDecoration(),
//                           child : Row(
//                             children: <Widget>[
//                               FutureBuilder(
//                                   future: checkLiked(),
//                                   builder:(context ,AsyncSnapshot<bool> asyncSnapshot) {
//                                     if(asyncSnapshot.hasData)
//                                     {
//                                       if(asyncSnapshot.data == false)
//                                       {
//                                         return IconButton(
//                                           onPressed: (){
//                                             increaseLikes();
//                                             sendNotification(id, snapshot);
//                                           },
//                                           icon: Icon(Icons.favorite_border,size: 25,),
//                                         );
//                                       }
//                                       else
//                                       {
//                                         return  IconButton(
//                                           onPressed: (){
//                                             decreaseLikes();
//                                           },
//                                           icon: Icon(Icons.favorite,size: 25,color: Colors.redAccent,),
//                                         );
//                                       }
//                                     }
//                                     else
//                                     {
//                                       return IconButton(
//                                         onPressed: (){
//                                           increaseLikes();
//                                         },
//                                         icon: Icon(Icons.favorite_border,size: 25,),
//                                       );
//                                     }
//                                   }
//                               ),
//                               InkWell(
//                                 onTap: (){
//                                   Navigator.push(context, MaterialPageRoute(
//                                       builder: (BuildContext context)
//                                       {
//                                         return AddComment(commentId: snapshot.documentID , imageUserId: snapshot['docId'], imageId: snapshot['image'],);
//                                       }
//                                   ));
//                                 },
//                                 child: Container(
//                                   height: 30,
//                                   width: 30,
//                                   child: Image(
//                                     image: AssetImage('assets/comment_icon.jpg'),
//                                   ),
//                                 ),
//                               ),
//                               FutureBuilder(future : getLikes() ,builder: (BuildContext context , AsyncSnapshot snapshot ){
//                                 if(snapshot.hasData && snapshot != null)
//                                 {
//                                   return Text(" Likes ${snapshot.data}");
//                                 }
//                                 return Container();
//                               })
//                               /*
//                                 IconButton(
//                                   onPressed: null,
//                                   icon: Icon(Icons.comment,
//                                       color: Colors.orangeAccent,
//                                       size : 30),
//                                 ),
//                                                     */
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 1,),
//                         //Text(totalLikes.toString())
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     return SafeArea(
//       child: Scaffold(
//         body :
//         Column(
//           children: [
//             ClipRRect(
//               child: Material(
//                 elevation: 20,
//                 child: Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             colors: [Colors.deepOrangeAccent , Colors.orange]
//                         )
//                     ),
//                     height: 55,
//                     width: MediaQuery.of(context).size.width,
//                     child: ListTile(
//                       title: Text(" Ecstasy", style:  TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         // fontWeight: FontWeight.bold
//                         // fontFamily: "Lobster"
//                       ),),
//                       trailing: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 5),
//                         child: InkWell(
//                           onTap: (){
//                             Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, anotherAnimation) {
//                               return MsgBox();
//                             }, transitionDuration: Duration(milliseconds: 300),
//                                 transitionsBuilder: (context, animation, anotherAnimation, child) {
//                                   animation = CurvedAnimation(curve: Curves.easeOut, parent: animation);
//                                   return Align(
//                                     child: ScaleTransition(
//                                       scale: animation,
//                                       child: child,
//                                     ),
//                                   );
//                                 })
//                             );
//                           },
//                           child: ClipOval(
//                             child: Material(
//                               elevation: 25,
//                               child: Container(
//                                 decoration: BoxDecoration(),
//                                 child: CircleAvatar(
//                                   radius: 20,
//                                   backgroundColor: Colors.white,
//                                   child:  Container(
//                                     child: ClipOval(
//                                       child: Material(
//                                         elevation: 10,
//                                         child: Icon(Icons.message_outlined, color: Colors.black,),
//                                         // child: Image.asset("assets/message_icon.png" , height: 32, width: 32,),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   //color: Colors.redAccent
//                 ),
//               ),
//               // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
//             ),
//             Expanded(
//               child: Container(
//                 child: ListView.builder(
//                   itemBuilder: (context, index) =>
//                       _buildNewPosts(
//                           context, posts[index] , index , posts.length),
//                   itemCount: posts.length,
//                 )
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//             backgroundColor: Colors.red,
//             child: InkWell(
//               onTap: () => {
//                 Navigator.pushNamed(context , '/uploadMyImage' )},
//               child: Icon(
//                 Icons.add,
//                 size: 35,
//               ),
//             )
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Home/MsgBox.dart';
import 'package:obvio/Home/SearchedUser.dart';
import 'package:obvio/Home/addComment.dart';
import 'package:obvio/Services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:obvio/Notification/notifications.dart';
import 'package:obvio/Utils/TimeConversion.dart';
import 'package:obvio/Utils/common_image_display_widget.dart';
class NewPosts extends StatefulWidget {
  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  final AuthService auth = AuthService();
  var name;
  String currentUser = '';
  int totalLikes = 0;
  TransformationController controller = TransformationController();
  String currentId = '' , currentProfile = '';
 FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  var profilePic = "";
  Future<void> sendNotification (var id , DocumentSnapshot snapshot)async{
    String token = '';
    Firestore.instance.collection("Ravan").document(snapshot.data['docId']).get().then((value){
      token = value['token'];
      print(" Token is $token ");
      sendAndRetrieveMessage(token, currentUser.toString() + " liked your photo.", "" , imgUrl: currentProfile , screen: 'Notification');
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
   var docId = snapshot.data["docId"];
    Firestore.instance.collection('Ravan').document(docId).collection('Notifications').add({
      'name' : currentUser,
      'email' : user.email,
      'imageId' : docId,
      'userId' : currentId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'profilepic' : currentProfile,
      'type' : "like",
      'imgUrl' : snapshot['image']
    });
  }

  void setName()
   async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
     setState(() {
       currentId = user.uid;
       print("Id is $currentId");
       Firestore.instance.collection('Ravan').document(currentId).get().then((value) => {
        currentUser = value["name"],
         currentProfile = value["image"],
        //print(currentProfile),
       Firestore.instance.collection('Ravan').document(currentId).get().then((value) async{
       print("token is ${value['token']}");
       })
      });
    });
  }
  getToken() async {
    String token = await firebaseMessaging.getToken();
    if(token != null)
      {
        Firestore.instance.collection('Ravan').document(currentId).updateData({
          "token" : token
        });
      }
    Firestore.instance.collection('Ravan').document(currentId).get().then((value) async{
      print("token is ${value['token']}");
       // Map<String , dynamic> response =  await sendAndRetrieveMessage(value['token'], "Hii Buddy", "How Are You");
       // print(" Response is ${response}");
    });
  }
  void initState(){
    super.initState();
    setName();
    getToken();
    // firebaseMessaging.configure(
    //   onMessage: (message ) async{
    //     print("Message ${message['notification']['title']}");
    //     return Scaffold.of(context).showSnackBar(SnackBar(content: message["notification"]["title"] , duration: Duration(seconds: 3),));
    //   },
    //   onResume: (message) async {
    //     Scaffold.of(context).showSnackBar(SnackBar(content: message["notification"]["title"],duration: Duration(seconds: 3),));
    //   }
    // );
  }

  var docId ;

  Widget _buildNewPosts(BuildContext context, DocumentSnapshot snapshot, int index ,int length) {
    TransformationController controller = TransformationController();
    String timeToDisplay = TimeConvert(snapshot['timestamp']);
    var id = snapshot.documentID;
    var increment , decrement;
    bool isLiked = false;
    int likes = 0;
    var icon;
    //
    Future<bool> checkLiked()
    async {
      var docs = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").getDocuments();
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

    Future<String> getProfileName()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['name']);
    }
    Future<int> getLikes() async{
     DocumentSnapshot documentSnapshot = await Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).get();
     return documentSnapshot.data['likes'];
    }
    void increaseLikes()
    async {
      Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(currentId).setData({
        "userId": currentId
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
      Firestore.instance.collection('Ravan').document(snapshot['docId']).collection("MyImages").document(snapshot.documentID).collection("Likes").document(currentId).delete();
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
    docId = snapshot['docId'];
    name = snapshot.data["name"];
    return Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 2),
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
                                                      fit: BoxFit.cover
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
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5 ,vertical: 3),
                                        child: InkWell(
                                          onTap: (){
                                            if(snapshot['docId'] == currentId)
                                              {
                                                Navigator.pushNamed(context, '/myProfile');
                                              }
                                            else
                                              {
                                                Navigator.push(
                                                  context , MaterialPageRoute(builder: (BuildContext context){
                                                    return SearchedUser(searchedId: snapshot['docId'], name: snapshot.data['name'],);
                                                 })
                                                );
                                                // Navigator.pushNamed(context, '/searchedUser' ,arguments: {
                                                //   'id' : snapshot['docId'],
                                                //   'name' : snapshot.data['name'],
                                                // });
                                              }
                                            },
                                          child: Text(snapshot.data['name'])
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 4,
                                        backgroundColor: Colors.red,),
                                      SizedBox(width: 9,),
                                      Text(TimeConvert(snapshot['timestamp']),style: TextStyle(
                                        color: Colors.black38
                                      ),)
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
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                  return ImageDisplay(imgUrl: snapshot["image"],);
                                }));
                              },
                              onDoubleTap: (){

                              },
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
                        ),
                        SizedBox(height: 1),
                        Container(
                            decoration: BoxDecoration(),
                            child : Row(
                              children: <Widget>[
                                FutureBuilder(
                                    future: checkLiked(),
                                    builder:(context ,AsyncSnapshot<bool> asyncSnapshot) {
                                      if(asyncSnapshot.hasData)
                                      {
                                        if(asyncSnapshot.data == false)
                                          {
                                            return IconButton(
                                              onPressed: (){
                                                increaseLikes();
                                                sendNotification(id, snapshot);
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
                                          return AddComment(commentId: snapshot.documentID , imageUserId: snapshot['docId'], imageId: snapshot['image'],);
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
                                      if(snapshot.hasData && snapshot != null)
                                        {
                                          return Text(" Likes ${snapshot.data}");
                                        }
                                      return Container();
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
                         SizedBox(height: 1,),
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Scaffold(
        body :
        Column(
          children: [
            ClipRRect(
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
                      title: Text(" Ecstasy", style:  TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                       // fontWeight: FontWeight.bold
                       // fontFamily: "Lobster"
                      ),),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, anotherAnimation) {
                              return MsgBox();
                            }, transitionDuration: Duration(milliseconds: 300),
                                transitionsBuilder: (context, animation, anotherAnimation, child) {
                                  animation = CurvedAnimation(curve: Curves.easeOut, parent: animation);
                                  return Align(
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                })
                            );
                          },
                          child: ClipOval(
                            child: Material(
                              elevation: 25,
                              child: Container(
                                decoration: BoxDecoration(),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child:  Container(
                                    child: ClipOval(
                                      child: Material(
                                        elevation: 10,
                                       child: Icon(Icons.message_outlined, color: Colors.black,),
                                       // child: Image.asset("assets/message_icon.png" , height: 32, width: 32,),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    //color: Colors.redAccent
                  ),
                ),
               // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: Firestore.instance.collection("Ravan").document(currentId).collection("NewsFeed").orderBy('timestamp' , descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                              else if(snapshot.data.documents.length < 1){
                                return Center(
                                  child: Text("Hello, $currentUser go and make friends !" , style: TextStyle(
                                    //  color: Colors.blue,
                                      fontSize: 18,
                                      //fontFamily: 'Pacifico'
                                  ),),
                                );
                              }
                              return ListView.builder(
                                itemBuilder: (context, index) =>
                                 _buildNewPosts(
                                context, snapshot.data.documents[index] , index , snapshot.data.documents.length),
                                itemCount: snapshot.data.documents.length,
                      );
                    }),
              ),
            ),
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

