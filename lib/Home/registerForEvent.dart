
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EventRegistration extends StatefulWidget {
  final String eventId;
  EventRegistration({this.eventId}){
    print(" ID $eventId");
  }
  @override
  _EventRegistrationState createState() => _EventRegistrationState(event: eventId);
}

class _EventRegistrationState extends State<EventRegistration> {

  String event;
  _EventRegistrationState({this.event})
  {
    print(" Event Id is $event");
    getRegisteredUser();
  }
  final formKey = GlobalKey<FormState>();
  String email = '';
  String contact = '';
  String name = '';
  String username = '';
  String error = '';
  String userId = '';
  bool isRegistered = false;
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
getUserId()async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = firebaseUser.uid;
      Firestore.instance.collection("Ravan").document(userId).get().then((value) {
        setState(() {
          nameController.text = value['name'];
          emailController.text = value['email'];
         email = value['email'];
          name = value['name'];
         print(" name And Email is $email $name");
        });
      });
    });
  }

 getRegisteredUser()async{
  Firestore.instance.collection("EventDetails").document(event).collection("Registered").getDocuments().then((value) {
     value.documents.forEach((element) {
       print(" Elemenr is ${element['uid']} $userId");
     });
     for(int i = 0; i < value.documents.length ; i++)
       {
         if(value.documents[i]['uid'] == userId)
         {
           print ("Flag Is True");
           setState(() {
             isRegistered = true;
           });
         }
         else
         {
           setState(() {
             isRegistered = false;
           });
           print ("Flag Is false");
         }
       }
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
        child:  isRegistered == false ? Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Center(
              child: Container(
                alignment: Alignment.center,

                padding: EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),

                child: ListView(
                  children: <Widget>[

                    SizedBox(height:20,),

                    TextFormField(
                      controller: nameController,
                      validator: (val) => val.isEmpty ? 'Enter an Name' : null,
                      autofocus: true,

                      // initialValue: name != '' ? name : "",
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.purple,
                        hoverColor: Colors.red,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
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
                      controller: emailController,
                      // initialValue: email != '' ? email : "",
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.purple,
                        hoverColor: Colors.red,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
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
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
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
        ) : Text(" You are Already Registered.")
      ),
    );
  }
}
