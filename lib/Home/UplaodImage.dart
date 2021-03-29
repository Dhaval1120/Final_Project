
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;

class UploadMyImage extends StatefulWidget {
  @override
  _UploadMyImageState createState() => _UploadMyImageState();
}

class _UploadMyImageState extends State<UploadMyImage> {
  File _image;
  var randomNumber = new Random();
  final picker = ImagePicker();
  String url;
  var uid , image_id;
  var i;
  var name;
  var profilepic;
 bool flagForCircle = false;

  void showAlertDialog() {
     showDialog(
        context: context,
        barrierDismissible: true,
          builder: (context){
           return AlertDialog(
             content: Text(" Succesfully Uploaded"),
             actions: <Widget>[
               FlatButton(
                 child: Text("Done"),
                 onPressed: () => Navigator.pop(context) ,
               )
             ],
           );
            }
          );
        }

   uploadPicture(var profilepic , var name1) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userId = user.uid;
    i = randomNumber.nextInt(100000);
    setState(() {
      flagForCircle = true;
    });
    StorageReference ref = FirebaseStorage.instance.ref().child(
        '${user.email}/${user.email}_${this.i}');
    StorageUploadTask uploadTask = ref.putFile((_image));

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    print(url);

    image_id = '${user.email}_${this.i}' ;


    Firestore.instance.collection("Ravan").document(uid).collection("MyImages").add({
      'image' : url,
      'likes' : 0,
      'datetime' : DateTime.now(),
      'name' : name,
      'id' : image_id,
      'time' : DateTime.now().toUtc().toString(),
      'docId' : userId,
      'timestamp' : DateTime.now().millisecondsSinceEpoch,
    }).then((doc) {
      Firestore.instance.collection("Ravan").document(userId).collection("Followers").getDocuments().then((value){
        value.documents.forEach((element) {
          Firestore.instance.collection("Ravan").document(element['docId']).collection('NewsFeed').document(doc.documentID).setData(
              {
                'image': url,
                'likes': 0,
                'profilepic' : profilepic,
                'name': name,
                'id' : image_id,
                'docId' : userId,
                'time' : DateTime.now().toUtc().toString(),
                'timestamp' : DateTime.now().millisecondsSinceEpoch,
              }
          );
        });
      });

    });


    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    setState(() {
      showAlertDialog();
      flagForCircle = false;
      print("Sucesfully uploaded");
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid);

    setState(() {
      uid = user.uid;
      print(uid);
    });

    Firestore.instance.collection('Ravan').document(uid).get().then((value) => {

      setState(() {
        name = value['name'];
        profilepic = value['image'];
      }) ,
     print(name),
//      name = value['name']
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    // getUserData();
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
          //  fontFamily: 'Pacifico',
            fontSize: 20.0,
            color: Colors.white
          ),
        ),
        backwardsCompatibility: false,
        actions: [
          _image != null ?   InkWell(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text('Upload',
                  style: TextStyle(
                   // fontFamily: 'Pacifico',
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            onTap:(){
              uploadPicture(profilepic ,name);
            },
          ) : Container()
        ],
        centerTitle: true,
         backgroundColor: Color(0xff09203f),
      ),

      body: flagForCircle == true ? Center(child: CircularProgressIndicator()) : Stack(

        children: <Widget>[
          Center(
            child: _image == null
                ? Text('No image selected.')
                : AspectRatio(
                 aspectRatio: 4/5,
                child: Container(
                    decoration: BoxDecoration(
                      border : Border.all(color: Colors.black)
                    ),
                    child: Image.file(_image , fit: BoxFit.cover,))),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Align(
          //       alignment: Alignment.bottomLeft,
          //       child: RaisedButton(child: Text("Add",
          //           style: TextStyle(fontSize:21 , fontFamily: 'Sriracha',color: Colors.white)),
          //           color: Colors.red,
          //           onPressed: () => uploadPicture(profilepic,name))
          //   ),
          // )
        ],
      ),

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