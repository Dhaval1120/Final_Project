import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Design/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchHere extends StatefulWidget {
  @override
  _SearchHereState createState() => _SearchHereState();
}

class _SearchHereState extends State<SearchHere> {
  final formKey = GlobalKey<FormState>();
  String search_text = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Search",
            style : TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

        ),

        body : Stack(
          children: <Widget>[
            Container(
              child : Background(),
            ),

            Column(
              children: <Widget>[
                Form(
                  key : formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                        ),
                        labelText : "Search",
                        filled: true,
                        focusColor: Colors.purple,
                        hoverColor: Colors.red,
                        fillColor: Colors.white,
                      ),

                      onChanged: (val){
                        setState(() {
                          search_text = val;

                          print(search_text.toLowerCase());
                        });
                      },


                    ),
                  ),
                ),
                SizedBox(height:15),

                RaisedButton(
                  color : Color(0xff000080),
                  hoverColor: Colors.blueAccent,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  splashColor: Colors.purple,
                  child: Text("Search",
                      style : TextStyle(
                          fontFamily: 'Pacifico',
                          color : Colors.white,
                          fontSize: 20
                      )

                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/listedUsers' , arguments: {
                      'name' : search_text,
                    });
                    print(search_text);
                  },
                ),
               ],
            ),
          ],
        ),
      ),
    );
  }
}

