import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obvio/Utils/theme_colors.dart';
class MsgBox extends StatefulWidget {
  @override
  _MsgBoxState createState() => _MsgBoxState();
}

class _MsgBoxState extends State<MsgBox> {

  var currentUser ='' , currentProfile ='' ,currentId = '';
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
      return await Firestore.instance.collection('Ravan').document(snapshot.data['Id']).get().then((value) => value.data['image']);
    }
    return InkWell(
      onTap: (){
        Firestore.instance.collection("Ravan").document(currentId).collection("MsgBox").document(snapshot.documentID).updateData({
          'isNewMessage' : false
        });
        Navigator.pushNamed(context, '/chatbox' , arguments: {
          'uid' : currentId,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5 ,vertical: 3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                  color: snapshot.data['isNewMessage'] != null && snapshot.data['isNewMessage']? Colors.redAccent :
                  Colors.black12
              ),
              child:  Row(
                children: <Widget>[
                  SizedBox(width: 4,),
                  CircleAvatar(
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
                                    image: CachedNetworkImageProvider(snapshot.data ,),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6 ,8 , 0 ,0),
                        child: Text(snapshot.data['name'],style: TextStyle(
                              fontSize: 17,
                              color: snapshot.data['isNewMessage'] != null && snapshot.data['isNewMessage'] ?
                                  Colors.white : Colors.black
                            ),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(6 ,8 , 0 ,3),
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width-120,
                          child: snapshot.data['type'] == 'image' ? Align(alignment : Alignment.topLeft,child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.image , size: 25,),
                              SizedBox(width: 3,),
                              Text("Photo" , style: TextStyle(fontSize: 20
                              ,color: snapshot.data['isNewMessage'] != null && snapshot.data['isNewMessage'] ?
                                  Colors.white : Colors.black
                              ),)
                                ],
                              )) : Text(snapshot.data['msg'], style: TextStyle(
                            fontSize: 16,
                              color: snapshot.data['isNewMessage'] != null && snapshot.data['isNewMessage'] ?
                              Colors.white : Colors.black
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
       // backgroundColor: Colors.black.withOpacity(0.3),
        body: Column(
          children: [
            ClipRRect(
                child: Material(
                  elevation: 20,
                  child: Container(
                      // decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //         colors: [Colors.deepOrangeAccent , Colors.orange]
                      //     )
                      // ),
                      color: appBarColor,
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: Text(" Messages ", style:  TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                        ),),
                      )
                    //color: Colors.redAccent
                  ),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
            ),
            Expanded(
              child: Container(
               child : currentId != "" ? StreamBuilder(
                 stream: Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').
                 orderBy('timestamp' ,descending: true ).snapshots(),
                 builder: (context , snapshot){
                   if(snapshot.connectionState == ConnectionState.active)
                     {
                       if(snapshot.data.documents.length < 1)
                       {
                         return Center(child: Text("No Chats" , style: TextStyle(fontSize: 18),));
                       }
                       else
                       {
                         return ListView.builder(
                           itemBuilder: (context ,index) => buildChats(context , snapshot.data.documents[index]),
                           itemCount: snapshot.data.documents.length,
                         );
                       }
                     }
                    return Container();
                 }
               ) : Container()
              ),
            ),
          ],
        ),
      )
    );
  }
}
