import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Authenticate/Register.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Home/SharedPre.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Authenticate/forgot_password.dart';
import 'package:obvio/Services/auth.dart';
import 'package:obvio/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();

  Icon icon1 = Icon(Icons.visibility);
  Icon icon2 = Icon(Icons.visibility_off_outlined);

  bool loading = false;
  bool isPasswordVisible = false;
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
                          TextFormField(
                            autofocus: true,
                            validator: (val) => val.length < 6 ? 'Enter a password 6 chars long': null,
                            decoration: InputDecoration(
                                suffixIcon: !isPasswordVisible ? IconButton(icon: icon1, onPressed: (){
                                  print("Before $isPasswordVisible");
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                  print("After $isPasswordVisible");
                                } , color: Colors.black,) : IconButton(icon: icon2, onPressed: (){
                                  print("Before $isPasswordVisible");
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                  print("After $isPasswordVisible");
                                }, color: Colors.black,),
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white,
                                 enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                              ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                                ),
                                labelText : "Password",
                              labelStyle: TextStyle(
                                color: Colors.black
                              ),
                              filled: true,
                              focusColor: Colors.purple
                            ),
                            obscureText: isPasswordVisible,
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

                                    FirebaseUser result = await auth.signInWithEmailAndPassword(email, password);
                                    if(result == null)
                                    {
                                      setState(() {
                                        loading = false;
                                        error = "Could not Sign In";
                                      });
                                    }
                                    else
                                      {
                                        setState(() {
                                          loading = false;
                                        });
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        sharedPreferences.setString("email", email);
                                        sharedPreferences.setString("password", password);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                                          return Home();
                                        }));//
                                        // if(result.isEmailVerified)
                                        //   {
                                        //     // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        //     // sharedPreferences.setString("email", email);
                                        //     // sharedPreferences.setString("password", password);
                                        //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                                        //     //   return Home();
                                        //     // }));//
                                        //   }
                                        // else
                                        //   {
                                        //     print(" Please Register again and Verify your mail !");
                                        //   }
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
                                  fontSize: 15
                              ),),
                          ),
                          SizedBox(
                              height : 5.0
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                Container(
                                  child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext context){
                                              return Register();
                                            }
                                        ));
                                        //auth.forgotPassWord(email);
                                      },
                                      child: Center(child: Text(" Create New Account or" , style: TextStyle(
                                          color: Colors.white
                                      ),))),
                                ),
                                Container(
                                  child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return ForgotPassword();
                                          }
                                        ));
                                        //auth.forgotPassWord(email);
                                      },
                                      child: Center(child: Text(" Forgot Password ?" , style: TextStyle(
                                        color: Colors.white
                                      ),))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height : 5.0
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: RaisedButton(
                          //     padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                          //     color : Color(0xff000080),
                          //     hoverColor: Colors.blueAccent,
                          //     elevation: 10.0,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(20)
                          //     ),
                          //     splashColor: Colors.purple,
                          //     child: Text("Register",
                          //         style : TextStyle(
                          //             fontFamily: 'Pacifico',
                          //             color : Colors.white,
                          //             fontSize: 20
                          //         )
                          //
                          //     ),
                          //     autofocus: true,
                          //     onPressed: () async{
                          //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          //         return Register();
                          //       }));
                          //     }
                          //     //Navigator.pushNamed(context, '/signUp');
                          //     //   dynamic result = await auth.signInWithEmailAndPassword(email, password);
                          //     //   if(result == null) {
                          //     //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                          //     //       return Register();
                          //     //     }));//  widget.toggleView();
                          //     //   }
                          //     // },
                          //   ),
                          // ),
                        ],
                      ),
                    //),
                    ),
                  ),
               ),
              ),


            // Align(
            //   alignment : Alignment.bottomCenter,
            //   child:
            // ),
          ]
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
