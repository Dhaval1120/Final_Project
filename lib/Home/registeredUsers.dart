import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredUsers extends StatefulWidget {
  final String docId;
  
  RegisteredUsers({this.docId});
  @override
  _RegisteredUsersState createState() => _RegisteredUsersState();
}

class _RegisteredUsersState extends State<RegisteredUsers> {

  List userData = List();
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
    getRegisteredUsers();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color:  Color(0xffda70d6),
        //  color: Colors.blue,
         child :userData.length != 0 ? ListView.builder(
              itemCount: userData.length,
             itemBuilder: (BuildContext context , int index){
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(5),
                   color: Colors.blue,
                 ),
                 child: ListTile(
                   title: Text(userData[index]['name'] ,style: TextStyle(color: Colors.white),),
                   subtitle: Text(userData[index]['email'],style: TextStyle(color: Colors.white)),
                 ),
               ),
             );
          }) : Center(child: Text(" No Users " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 25 ,fontFamily: 'Sriracha'),),)
        ),
      ),
    );
  }
}
