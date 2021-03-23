import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Services/auth.dart';
import 'package:obvio/Home/home.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
        title: Text("Ecstasy",
            style : TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 20.0,
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
                height: 300,
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

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                                ),
                              labelText : "E-mail or Phone",
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
                          TextFormField(
                            autofocus: true,
                            validator: (val) => val.length < 6 ? 'Enter a password 6 chars long': null,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                              ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                                ),

                                labelText : "Password",
                              filled: true,
                              focusColor: Colors.purple
                            ),
                            obscureText: true,
                            onChanged: (val){
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(
                            height : 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),

                              color : Color(0xff000080) ,
                              child: Text(' Sign In ',
                                style : TextStyle (
                                  fontFamily: 'Pacifico',
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side : BorderSide(color : Color(0xff29323c))
                              ),

                             elevation: 6.0,
                              autofocus: true,
                              splashColor: Colors.purple,
                              onPressed: () async{
                   //             widget.toggleView();

                                if(formKey.currentState.validate())
                                  {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await auth.signInWithEmailAndPassword(email, password);

                                    if(result == null)
                                    {
                                      setState(() {
                                        loading = false;
                                        error = "Could not Sign In";
                                      });
                                    }
                                  }
                                },
                            ),
                          ),
                          SizedBox(
                              height : 5.0
                          ),
                          Center(
                            child: Text(error,
                              style: TextStyle(
                              //  backgroundColor: Colors.white,
                                  color: Colors.white,
                                  fontSize: 17
                              ),),
                          ),
                        ],
                      ),
                    //),
                    ),
                  ),
               ),
              ),


            Align(
              alignment : Alignment.bottomCenter,
              child: RaisedButton(

                padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                color : Color(0xff000080),
                hoverColor: Colors.blueAccent,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
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
                  //Navigator.pushNamed(context, '/signUp');
                  dynamic result = await auth.signInWithEmailAndPassword(email, password);
                  if(result == null) {
                    widget.toggleView();
                  }
                },
              ),
            ),
          ]
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
