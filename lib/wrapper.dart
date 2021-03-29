import 'package:flutter/material.dart';
import 'package:obvio/Authenticate/authenticate.dart';
import 'package:obvio/Home/SharedPre.dart';
import 'package:obvio/Home/home.dart';
import 'package:provider/provider.dart';
import 'package:obvio/Model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authenticate/sign_in.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool flag;
  getSharedPref() async{
    SharedPreferences.getInstance().then((value) {
      if(value.getString("email")  != null && value.getString("password") != null)
      {
        print("Flag $flag");
        setState(() {
          flag = true;
        });
      }
      else
        {
          print("Flag $flag");
          setState(() {
            flag = false;
          });
        }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {

    //return Home();
    if(flag != null) {
      if (flag == true) {
        return Home();
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (BuildContext context) {
        //   return Home();
        // }));
      }
      else {
        return SignIn();
      }
    }else
      {
        return Container();
      }
    //flag != null ? flag == true ? Home() : SignIn() : Container();
   // final user = Provider.of<User>(context);
   //  print(user);
   //  if(user == null)
   //    {
   //      return Authenticate();
   //    }
   //  else
   //    {
   //      return Home();
   //    }
  }
}
