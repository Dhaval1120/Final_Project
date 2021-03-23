import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MsgBox extends StatefulWidget {
  @override
  _MsgBoxState createState() => _MsgBoxState();
}

class _MsgBoxState extends State<MsgBox> {

  var currentUser , currentProfile ,currentId;

  void setName()
  async{

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('Ravan').document(user.uid).get().then((value) {

     setState(() {

       currentUser = value["name"];
       currentId = user.uid;
       currentProfile = value["image"];

     });//print(currentProfile),
    });

  }
/*
  Future getPosts() async{
   QuerySnapshot querySnapshot = await Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').getDocuments();

   querySnapshot.documents.forEach((element) {
    return element.data['name'];
       });
 }*/

  Widget buildChats(BuildContext context , DocumentSnapshot snapshot)
  {


    Future<String> getProfile()
    async {

      //print(snapshot.documentID);
      //print('getPro');
      return await Firestore.instance.collection('Ravan').document(snapshot.data['Id']).get().then((value) => value.data['image']);

      // return userProfile;

    }
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/chatbox' , arguments: {
          'currentId' : currentId,
          'friendId' : snapshot.data['Id'],
        });
      },
      child: GestureDetector(
        onLongPress: (){
          return showDialog(context: context ,
          barrierDismissible: true,
            builder: (context){
             return  AlertDialog(
               title: InkWell(
                   onTap: (){
                     Firestore.instance.collection('Ravan').document(currentId)
                         .collection('MsgBox').document(snapshot.documentID).delete().then((value){
                       Navigator.pop(context);
                     });
                   },
                   child: Text('Delete ' ,
                     style: TextStyle(fontSize: 18),
                   )
               ),
             );
            });
        },
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: FutureBuilder(
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
           //     mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      height: 22,
                      child: Text(snapshot.data['name'],style: TextStyle(
                            fontSize: 20,
                          ),),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width-120,
                      child: snapshot.data['type'] == 'image' ? Align(alignment : Alignment.topLeft,child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.image , size: 25,),
                          SizedBox(width: 3,),
                          Text("Photo" , style: TextStyle(fontSize: 20),)
                        ],
                      )) : Text(snapshot.data['msg'], style: TextStyle(
                        fontSize: 18
                      ),
                        overflow: TextOverflow.ellipsis,
                        //softWrap: false,

                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setName();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,

          title: Text("Chats",
            style : TextStyle(
              // fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

        ),
        body: Container(
         child : StreamBuilder(
           stream: Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').
           orderBy('timestamp' ,descending: true ).snapshots(),
           builder: (context , snapshot){
             if(snapshot.data.documents.length < 1)
               {
                 return Center(child: Text("NO Chats" , style: TextStyle(fontSize: 20),));
               }
             else
               {
                 return ListView.builder(
                     itemBuilder: (context ,index) => buildChats(context , snapshot.data.documents[index]),
                         itemCount: snapshot.data.documents.length,

                 );
               }
           }
         )
        ),
      )
    );
  }
}
