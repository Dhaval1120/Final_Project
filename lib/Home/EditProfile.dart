import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:obvio/Authenticate/sign_in.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String currentId = '',currentName = '',currentProfile = '' , bio = '' , userName =' ';

  void setName()
  async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = user.uid;
      Firestore.instance.collection('Ravan').document(currentId).get().then((value) {
        setState(() {
          currentName = value["name"];
          currentProfile = value["image"];
          bio = value['bio'] ?? '';
          userName = value['username'];
        });
        print(" name $currentName $bio");
        //print(currentProfile),
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setName();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ClipRRect(
                child: Material(
                  elevation: 20,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.deepOrangeAccent , Colors.orange]
                          )
                      ),
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back , color: Colors.white,)),
                        title: Text(" Edit Profile ", style:  TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            //fontFamily: "Lobster"
                        ),),
                        trailing: InkWell(
                            onTap: (){
                              Firestore.instance.collection('Ravan').document(currentId).updateData({
                                'name' : currentName,
                                'username' : userName,
                                'bio' : bio
                              }).then((value) => Navigator.pop(context));
                            },
                            child: Text(" Done " , style: TextStyle(color: Colors.white , fontSize: 18),)),
                      )
                    //color: Colors.redAccent
                  ),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
            ),
            Expanded(
              child: Container(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 100,
                          child: ClipOval(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: InkWell(
                                child: Image(
                                    image: CachedNetworkImageProvider(currentProfile),
                                    //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                    fit: BoxFit.contain
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 5,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: currentName,
                          maxLength: 30,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,
                            border : OutlineInputBorder(),
                            labelText : "Name",
                            labelStyle: TextStyle(
                              color: Colors.black
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple,width: 2)
                            ),
                          ),
                          onChanged: (val)
                          {
                            currentName = val;
                          },

                        ),
                      ),

                      SizedBox(height : 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: userName,
                          maxLength: 30,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            border : OutlineInputBorder(),
                            labelText : "Username",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple,width: 2)
                            ),
                          ),
                          onChanged: (val)
                          {
                            userName = val;
                          },
                        ),
                      ),
                      SizedBox(height : 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: bio,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Colors.purple,
                            hoverColor: Colors.red,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            border : OutlineInputBorder(),
                            labelText : "Bio",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple,width: 2)
                            ),
                          ),
                          onChanged: (val)
                          {
                            bio = val;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
