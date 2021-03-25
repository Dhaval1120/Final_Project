import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Home/UserEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegisteredUsers extends StatefulWidget {
  final String docId;
  
  RegisteredUsers({this.docId});
  @override
  _RegisteredUsersState createState() => _RegisteredUsersState();
}

class _RegisteredUsersState extends State<RegisteredUsers> {

  String message ='' , currentId = '';
  List userData = List();
  sendMessages()async{

    for(int i =0 ; i< userData.length ; i++)
      {
        int collectionId = currentId.hashCode - userData[i]['uid'].hashCode;
        print("collection id is $collectionId");
        String friendPic = '', friendName = '';
        Firestore.instance.collection("Ravan").document(userData[i]['uid'].toString()).get().then((value) {
          setState(() {
            print(" Name is ${value['name']} Image is ${value['image']}");
            friendName = value['name'];
            friendPic = value['image'];
          });
          Firestore.instance.collection('Ravan').document(currentId).collection(collectionId.toString()).add({
            'msg' : message,
            'sent' : true,
            'received' : false,
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          });
          Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').document(userData[i]['uid']).setData({
            'Id' : userData[i]['uid'],
            'Pic' : friendPic,
            'msg' : message ,
            'name' : friendName,
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          });
          Firestore.instance.collection('Ravan').document(userData[i]['uid']).collection(collectionId.toString()).add({
            'msg' : message,
            'sent' : false,
            'received' : true,
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          });
          Firestore.instance.collection('Ravan').document(userData[i]['uid']).collection('MsgBox').document(currentId).setData({
            'Id' : userData[i]['uid'],
            'Pic' : friendPic,
            'msg' : message ,
            'name' : friendName,
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          });
        });

      }
   }
  getUserId()async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = firebaseUser.uid;
    });
  }
  getRegisteredUsers()async{
    print(" DOC ID ${widget.docId}");
    Firestore.instance.collection("EventDetails").document(widget.docId).collection("Registered").getDocuments().then((value){
      value.documents.forEach((element) {
        setState(() {
          userData.add(element);
        });
      });
      print(" len is ${userData.length}");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    getRegisteredUsers();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
         // color:  Color(0xffda70d6),
        //  color: Colors.blue,
         child :userData.length != 0 ? ListView.builder(
              itemCount: userData.length,
             itemBuilder: (BuildContext context , int index){
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(5),
                   color: Colors.redAccent,
                 ),
                 child: ListTile(
                   title: Text(userData[index]['name'] ,style: TextStyle(color: Colors.white),),
                   subtitle: Text(userData[index]['email'],style: TextStyle(color: Colors.white)),
                 ),
               ),
             );
          }) : Center(child: Text(" No Users " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 25 ,fontFamily: 'Sriracha'),),)
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.message_outlined),
          onPressed: ()async{
            return showDialog(context: context , barrierDismissible: true , builder: (BuildContext context){

              return AlertDialog(
                title: Text(" Type Message "),
                content: Row(
                  children: [
                    Expanded(
                      child: TextField(
                         decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.cyan),
                             borderRadius: BorderRadius.circular(5)
                           ),
                             focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.indigo),
                             borderRadius: BorderRadius.circular(5)
                         )
                         ),
                        onChanged: (value){
                          setState(() {
                            message = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 5,),
                    ClipOval(
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          sendMessages();
                        },
                        child: Container(
                          color: Colors.pinkAccent,
                          height: 60,
                          width: 60,
                          child: Icon(Icons.send, color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
