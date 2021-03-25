import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Services/auth.dart';

class ImagePick extends StatefulWidget {
  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File _image;


  final picker = ImagePicker();
  String url;
  var uid;
  bool flagForCircle = false;
  //static StorageReference ref = FirebaseStorage.instance.ref().child('shirley1');

 // var url = ref.getDownloadURL();

  Future uploadProfilePicture() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    setState(() {
      flagForCircle = true;
    });
    StorageReference ref = FirebaseStorage.instance.ref().child('${user.email}/${user.email}_profilepic');
    StorageUploadTask uploadTask = ref.putFile((_image));

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    print(url);

    Firestore.instance.collection('Ravan').document(uid).updateData({
      'image' : url,
    });

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    setState(() {
      flagForCircle = false;
      Navigator.pop(context);
      print("Sucesfully uploaded");
    });
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void getUid()
   async {
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print(user.uid);
     setState(() {
       uid = user.uid;
     });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getUid();
  }
  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
       appBar: AppBar(
        elevation: 3.0,
        brightness: Brightness.dark,
        titleSpacing: 2.0,
        title: Text("Image",
          style : TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 20.0,
          ),
        ),
        /*actions: <Widget>[
          InkWell(
            child: Text('Upload',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20.0,

                ),
            ),
            onTap: uploadProfilePicture,
           )*/
        //],
        centerTitle: true,
        backgroundColor: Color(0xff09203f),
      ),

      body: !flagForCircle ?  Stack(

        children: <Widget>[
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RaisedButton(child: Text("Add",
                      style: TextStyle(fontSize:21 , fontFamily: 'Sriracha',color: Colors.white)),
                      color: Colors.red,
                      onPressed: uploadProfilePicture)
              ),
            ),
          )

        ],

      ) : Center(child: CircularProgressIndicator()),


      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo,
        color: Colors.white,),
        backgroundColor: Color(0xff09203f),
      ),
    );
  }
}
