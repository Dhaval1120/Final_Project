import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EventRegistration extends StatefulWidget {
  final String eventId;
  EventRegistration({this.eventId}){
    print(" ID $eventId");
  }
  @override
  _EventRegistrationState createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {

  final formKey = GlobalKey<FormState>();
  String email = '';
  String contact = '';
  String name = '';
  String username = '';
  String error = '';
  String userId = '';

  getUserId()async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = firebaseUser.uid;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(color: Colors.pinkAccent,
         child: Padding(
           padding: EdgeInsets.all(10),
           child: Form(
           key: formKey,
           child: Center(
             child: Container(
               alignment: Alignment.center,

               padding: EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),

               child: ListView(
                 //mainAxisAlignment: MainAxisAlignment.start,
                 // crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[

                   SizedBox(height:20,),

                   TextFormField(
                     validator: (val) => val.isEmpty ? 'Enter an Name' : null,
                     autofocus: true,

                     decoration: InputDecoration(
                       filled: true,
                       focusColor: Colors.purple,
                       hoverColor: Colors.red,
                       fillColor: Colors.white,

                       errorStyle: TextStyle(color: Colors.black),
                       border : OutlineInputBorder(),
                       labelText : "Name",

                       enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.white,width: 2)
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.red,width: 2)
                       ),
                     ),

                     onChanged: (val)
                     {
                       name = val;
                     },
                   ),

                   SizedBox(height : 10),

                   TextFormField(
                     validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                     autofocus: true,
                     decoration: InputDecoration(
                       filled: true,
                       focusColor: Colors.purple,
                       hoverColor: Colors.red,
                       fillColor: Colors.white,

                       errorStyle: TextStyle(color: Colors.black),
                       border: OutlineInputBorder(),
                       labelText : "E-mail",

                       enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.white,width: 2)
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.red,width: 2)
                       ),
                     ),
                     onChanged: (val){
                       setState(() {
                         email = val;
                       });
                     },
                   ),


                   SizedBox(height : 10),

                   TextFormField(
                     validator: (val) => val.length < 10 ? 'Enter a valid contact No' : null,
                     autofocus: true,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                       filled: true,
                       focusColor: Colors.purple,
                       hoverColor: Colors.red,
                       fillColor: Colors.white,

                       errorStyle: TextStyle(color: Colors.black),
                       border: OutlineInputBorder(),
                       labelText : "Contact No.",

                       enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.white,width: 2)
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.red,width: 2)
                       ),

                     ),
                     onChanged: (val){
                       setState(() {
                         contact = val;
                       });
                     },
                   ),

                   SizedBox (height : 10),

                   Align(
                     alignment : Alignment.bottomCenter,
                     child: RaisedButton(
                         padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                         color : Color(0xff000080),
                         hoverColor: Colors.cyan,
                         elevation: 3.0,
                         splashColor: Colors.purple,
                         child: Text("Register",
                             style : TextStyle(
                                 fontFamily: 'Pacifico',
                                 color : Colors.white,
                                 fontSize: 20
                             )

                         ),
                         autofocus: true,
                         onPressed: () async{
                         bool validate = formKey.currentState.validate();
                         if(validate)
                           {
                             Firestore.instance.collection('EventDetails').document(widget.eventId).collection("Registered").add({
                               'name' : name,
                               'email' : email,
                               'contact' : contact,
                               'uid' : userId
                             });
                             Firestore.instance.collection('Ravan').document(userId).collection('RegisteredEvents').add({
                               'eventId' : widget.eventId,
                               'timeStamp' : DateTime.now().toUtc().toString()
                             });
                             Navigator.pop(context);
                           }
                         }
                     ),
                   ),
                   SizedBox(
                       height : 10.0
                   ),
                   Center(

                     child: Text(error,
                       style: TextStyle(
                           backgroundColor: Colors.white,
                           color: Colors.pink,
                           fontSize: 15
                       ),),
                   ),
                   SizedBox(height : 5),
                   Align(
                     alignment : Alignment.bottomCenter,
                     child: RaisedButton(
                         padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                         color : Color(0xff000080),
                         hoverColor: Colors.cyan,
                         elevation: 3.0,
                         splashColor: Colors.purple,
                         child: Text("Cancel",
                             style : TextStyle(
                                 fontFamily: 'Pacifico',
                                 color : Colors.white,
                                 fontSize: 20
                             )

                         ),
                         autofocus: true,
                         onPressed: () {
                           Navigator.pop(context);
                         }
                     ),

                   ),
                 ],
               ),
               // ),
             ),
           ),
         ),
         ),
        ),
      ),
    );
  }
}
