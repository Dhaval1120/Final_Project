import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Authenticate/Register.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Home/SharedPre.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Services/auth.dart';
import 'package:obvio/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ForgotPassword extends StatefulWidget {
  final Function toggleView;
  ForgotPassword({this.toggleView});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 8.0,

        brightness: Brightness.dark,
        titleSpacing: 2.0,
        leading: Container(),
        title: Text("Forgot Password",
            style : TextStyle(
                //fontFamily: 'Pacifico',
                fontSize: 20.0,
                color: Colors.white
            )

        ),
        centerTitle: true,
        backgroundColor: Color(0xff09203f),

      ),
      body : Stack(
          children : <Widget>[
            Container(
              child : Background(),
            ),
            Form(
              key: formKey,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  //  height: 300,
                  padding: EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),

                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children : <Widget>[
                        SizedBox(
                            height : 15
                        ),
                        TextFormField(
                          autofocus: false,
                          validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                            ),
                            labelText : "E-mail or Phone",
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,
                          ),
                          onChanged: (val){
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(
                          height : 10,
                        ),
                        InkWell(
                          onTap: (){
                            if(formKey.currentState.validate())
                              {
                                auth.forgotPassWord(email);
                              }
                          },
                          child: Center(
                            child: CircleAvatar(
                              child: Icon(Icons.arrow_forward_rounded),
                            ),
                          ),
                        )
                      ],
                    ),
                    //),
                  ),
                ),
              ),
            ),
          ]
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
