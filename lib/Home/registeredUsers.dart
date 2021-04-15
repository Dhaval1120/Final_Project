import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Home/ChatBox.dart';
import 'package:obvio/Home/UserEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obvio/Notification/notifications.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:obvio/Utils/theme_colors.dart';


class RegisteredUsers extends StatefulWidget {
  final String docId;
  
  RegisteredUsers({this.docId});
  @override
  _RegisteredUsersState createState() => _RegisteredUsersState();
}

class _RegisteredUsersState extends State<RegisteredUsers> {

  String message ='' , currentId = '' , currentName ='' , currentPic = '' ,currentMail = '';
  List userData = List();
  String sendInMail = '';
  sendMessages()async{
    for(int i =0 ; i< userData.length ; i++)
      {
        int collectionId = currentId.hashCode - userData[i]['uid'].hashCode;
        print("collection id is $collectionId");
        String friendPic = '', friendName = '';

        Firestore.instance.collection("Ravan").document(userData[i]['uid']).get().then((value) {
          sendAndRetrieveMessage(value.data['token'], message, "$currentName sent you a message."
          , screen: 'MsgBox()'
          );
        });

        Firestore.instance.collection("Ravan").document(userData[i]['uid']).updateData({
          'isNewMessages' : true
        });
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
            'Id' : currentId,
            'Pic' : currentPic,
            'msg' : message ,
            'name' : currentName,
            'isNewMessage' : true,
            'timestamp' : DateTime.now().millisecondsSinceEpoch
          });
        });
      }
   }

   sendEmail(BuildContext context) async{
    //print(" Email Str is $sendInMail");

   }
  getUserId()async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = firebaseUser.uid;
    });
    Firestore.instance.collection("Ravan").document(currentId).get().then((value) {
      setState(() {
        currentName = value.data['name'];
        currentPic = value.data['image'];
        currentMail = value.data['email'];
      });
    });
  }
  getRegisteredUsers()async{
    print(" DOC ID ${widget.docId}");
    Firestore.instance.collection("EventDetails").document(widget.docId).collection("Registered").getDocuments().then((value){
      value.documents.forEach((element) {
        print('name is ${element['name']} ${element['email']}');
        setState(() {
          sendInMail = sendInMail + '\n';
          sendInMail = "\n" + sendInMail + element['name'] + " : " + element['email'];
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

  Future<String> getProfile(String id)
  async {
    return await Firestore.instance.collection('Ravan').document(id).get().then((value) => value.data['image']);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context)
          {
            return Container(
              // color:  Color(0xffda70d6),
              //  color: Colors.blue,
                child :userData.length != 0 ? Column(
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
                                leading: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back , color: Colors.white,),
                                ),
                                title: Text(" Registered ", style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  //fontFamily: "Lobster"
                                ),),
                                trailing: IconButton(
                                  icon: Icon(Icons.email_outlined ,color: Colors.white,),
                                  onPressed: () async {
                                    Email email = Email(
                                      body: sendInMail,
                                      recipients: [currentMail],
                                    );
                                    await FlutterEmailSender.send(email).then((value) {
                                      SnackBar snackBar = SnackBar(content: Text('Email is Sent to you.') , duration: Duration(seconds: 3),);
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });
                                    // sendEmail(context);
                                  },
                                ),
                              )
                            //color: Colors.redAccent
                          ),
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
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
                                    leading:  CircleAvatar(
                                        radius: 20,
                                        child : FutureBuilder(
                                            future: getProfile(userData[index]['uid']),
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
                                                return Icon(
                                                  Icons.person,
                                                );
                                              }
                                            }
                                        )
                                    ),
                                    title: Text(userData[index]['name'] ,style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,),
                                    subtitle: Text(userData[index]['email'],style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(icon : Icon(Icons.message_outlined), onPressed: (){
                                      Navigator.pushNamed(context, '/chatbox' , arguments: {
                                        'uid' : currentId,
                                        'friendId' : userData[index]['uid'],
                                      });
                                    },
                                      color: Colors.white,),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ) : Center(child: Text(" No Users " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),)
            );
          },
        ),

        floatingActionButton: userData.isNotEmpty ? FloatingActionButton(
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
        ) : Container()
      )
    );
  }
}
