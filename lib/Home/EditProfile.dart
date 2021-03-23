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


  var currentId,currentName,currentProfile;
  void setName()
  async{


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //FirebaseUser user = await FirebaseAuth.instance.currentUser();

    setState(() {
      currentId = user.uid;
      Firestore.instance.collection('Ravan').document(currentId).get().then((value) => {
        currentName = value["name"],
        currentProfile = value["image"],
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

  var name,username,bio;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Edit Profile",
            style : TextStyle(
            //  fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('Ravan').document(currentId).snapshots(),
          builder :(context ,snapshot )
          {

           void setInitialValues()
            {
                name = snapshot.data['name'];
                username = snapshot.data['username'];
                bio = snapshot.data['bio'];

            }

            setInitialValues();
            return Container(
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

                              image: CachedNetworkImageProvider(
                                  snapshot.data["image"]),
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
                    initialValue: snapshot.data['name'],
                    maxLength: 30,
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
                          borderSide: BorderSide(color: Colors.deepPurple,width: 2)
                      ),
                    ),
                    onChanged: (val)
                    {
                      name = val;
                    },

                  ),
                ),

                SizedBox(height : 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(

                    initialValue: snapshot.data['username'],
                    maxLength: 30,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.purple,
                      hoverColor: Colors.red,
                      fillColor: Colors.white,

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
                      username = val;
                    },

                  ),
                ),


                SizedBox(height : 5),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(

                    initialValue: snapshot.data['bio'],
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,

                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.purple,
                      hoverColor: Colors.red,
                      fillColor: Colors.white,

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


                Center(
                  child: RaisedButton(
                    color : Color(0xff7fffd4),

                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side : BorderSide(color : Color(0xff29323c))
                    ),

                    elevation: 6,
                    onPressed: (){
                      Firestore.instance.collection('Ravan').document(currentId).updateData({
                        'name' : name,
                        'username' : username,
                        'bio' : bio
                      }).then((value) => Navigator.pop(context));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Save' ,
                          style: TextStyle(
                              fontSize: 25 ,
                              color: Colors.white ,
                              fontFamily: 'Pacifico'
                          )
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
          }
        ),
      )
    );
  }
}
