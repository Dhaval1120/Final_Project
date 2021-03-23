import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String username = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          elevation: 8.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Sign Up",
            style : TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),
        ),

        body: Stack(

          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child : Background(),
            ),

            Form(
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

                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,

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

                          autofocus: true,

                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,


                            border : OutlineInputBorder(),
                            labelText : " UserName",

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2)
                            ),
                          ),
                          onChanged: (val)
                          {
                            username = val;
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
                          validator: (val) => val.length < 6 ? 'Enter a password 6 chars long' : null,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,

                            border: OutlineInputBorder(),
                            labelText : "Password",

                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2)
                            ),

                          ),
                          obscureText: true,
                          onChanged: (val){
                            setState(() {
                              password = val;
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
                             if(formKey.currentState.validate())
                               {
                                 setState(() {
                                   loading = true;
                                 });
                                 dynamic result = await auth.registerWithEmailAndPassword(email, password , name , username);
                                 if(result == null) {

                                   setState(() {
                                     loading = false;
                                     error = "Please supply valid email";
                                   });
                                 }
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

                                 widget.toggleView();
                            }
                        ),

                      ),
                    ],
                  ),
               // ),

              ),
            ),

            ),
          ],
        )

    );
  }
}

