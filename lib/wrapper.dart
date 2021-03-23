import 'package:flutter/material.dart';
import 'package:obvio/Authenticate/authenticate.dart';
import 'package:obvio/Home/home.dart';
import 'package:provider/provider.dart';
import 'package:obvio/Model/user.dart';
class Wrapper extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);


     //return ImagePick();
    if(user == null)
      {
        return Authenticate();
      }
    else
      {
        return Home();
      }
  }
}
