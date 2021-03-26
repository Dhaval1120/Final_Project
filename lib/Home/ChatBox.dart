import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:obvio/Notification/notifications.dart';
import 'package:obvio/Utils/common_image_display_widget.dart';
class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final formKey = GlobalKey<FormState>();
  bool isUploading = false;
  var currentId,currentName,friendId ,msgId, friendPic ,currentPic;
  String msg;
  TextEditingController myController;
  Widget _buildMsg(BuildContext context , DocumentSnapshot snapshot)
  {
    if(snapshot['sent'] == true)
      {
        if(snapshot['type'] == 'image')
          {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 5),
              child: Align(
                alignment: Alignment.topRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 350
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          return ImageDisplay(imgUrl: snapshot["msg"],);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                        ),
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width - 120,
                        child: CachedNetworkImage(
                          imageUrl: snapshot["msg"],
                          imageBuilder: (context , imageProvider) => Container(
                            decoration: BoxDecoration(
                                image : DecorationImage(
                                  image : imageProvider,
                                  fit : BoxFit.cover,
                                )
                            ),
                          ),
                          placeholder: (context , url) => Center(child: CircularProgressIndicator(backgroundColor: Colors.indigo,)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            //print(snapshot['msg']);
          }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:(MediaQuery.of(context).size.width)/2 + 30,
              ),
              child: InkWell(
                onLongPress: (){
                  showDialog(context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      content: Text("Delete Message ?"),
                      actions: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height:5),
                            InkWell(
                              onTap: (){
                                Firestore.instance.collection('Ravan').document(currentId).collection(msgId.toString())
                                    .document(snapshot.documentID).delete();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                      child: Text(
                                        'Delete for me' ,
                                        style: TextStyle(fontSize: 18,color: Colors.deepPurple),)),
                                )),
                          ],
                        )
                      ],
                    ),
                  );
                  },


                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [Colors.deepOrangeAccent , Colors.orange]
                      )
                      //color : Color(0xff66cdaa)
                    ),
                    child: Padding(

                      padding: const EdgeInsets.all(6),
                        child: Text(snapshot['msg'],
                        style: TextStyle(
                          fontSize: 20,
                              color: Colors.white,
                        ),),

                    ),
                  ),
              ),
            ),
          ),
        );
      }
    else
      {
        if(snapshot['type'] == 'image')
        {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8 ,vertical: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 350),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return ImageDisplay(imgUrl: snapshot["msg"],);
                      }));
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                     // height: 375,
                      width: MediaQuery.of(context).size.width - 120,
                      child: CachedNetworkImage(
                        imageUrl: snapshot["msg"],
                        imageBuilder: (context , imageProvider) => Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(10),
                              image : DecorationImage(
                                image : imageProvider,
                                fit : BoxFit.cover,
                              )
                          ),
                        ),
                        placeholder: (context , url) => Center(child: CircularProgressIndicator(backgroundColor: Colors.indigo,)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          //print(snapshot['msg']);
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width)/2
              ),
              child: InkWell(
                onLongPress: (){
                  showDialog(context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      content: Text("Delete Message ?"),
                      actions: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Firestore.instance.collection('Ravan').document(currentId).collection(msgId.toString())
                                    .document(snapshot.documentID).delete().then((value)  {
                                      Navigator.pop(context);
                                });
                              },
                              child: Text('Yes' , style: TextStyle(fontSize: 18),),
                            ),

                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text('No' ,style: TextStyle(fontSize: 18),),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.redAccent , Colors.orange]
                    )
                    //color: Color(0xffcd5c5c)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(6),
                      child: Text(snapshot['msg'] , style: TextStyle(
                        fontSize: 20,
                        color: Colors.white

                      ),),

                  ),
                ),
              ),
            ),
          ),
        );
      }

  }

  Future uploadImage () async
  {
//    var userId = user.uid;
    i = randomNumber.nextInt(100000);

    setState(() {
      isUploading = true;
    });
    StorageReference ref = FirebaseStorage.instance.ref().child(
        '${currentId}/${currentId}_${this.i}');
    StorageUploadTask uploadTask = ref.putFile((_image));

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    print(url);

    Firestore.instance.collection('Ravan').document(currentId).collection(msgId.toString()).add({
      'type' : 'image',
      'msg' : url,
      'sent' : true,
      'received' : false,
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });
    Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').document(friendId).setData({
      'Id' : friendId,
      'Pic' : friendPic,
      'type' : 'image',
      'msg' : url ,
      'name' : friendName,
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });

    Firestore.instance.collection('Ravan').document(friendId).collection('MsgBox').document(currentId).setData({
      'Id' : currentId,
      'Pic' : currentPic,
      'type' : 'image',
      'msg' : url ,
      'name' : currentName,
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });

    Firestore.instance.collection('Ravan').document(friendId).collection(msgId.toString()).add({
      'type' : 'image',
      'msg' : url,
      'received' : true,
      'sent' : false ,
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      isUploading = false;
    });

  }
  int i;
  var url;
  var randomNumber = new Random();
  File _image;
  final picker = ImagePicker();
  Future getImage() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState((){
      _image = File(pickedFile.path);
      uploadImage();
    });
  }

  ScrollController scrollController;

  setScrollPostion()async{
    Future.delayed(Duration(seconds: 2)).then((value) {
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 2000), curve: Curves.easeOutQuint);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = new ScrollController();
    setScrollPostion();
    myController = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  String friendName = ""; String token = '';
  void getName(){
    Firestore.instance.collection('Ravan').document(friendId).get().then((value) {
      setState(() {
        friendName = value['name'];
        friendPic = value['image'];
        token = value['token'];
       // print(friendName);
      });
      });
    Firestore.instance.collection('Ravan').document(currentId).get().then((value){
    setState(() {
      currentName = value['name'];
      currentPic = value ['image'];
      // Pic = value['image'],
     // print(friendName);
    });
    });

  }

  @override

  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    currentId = data['currentId'];
    //print(currentId);
    friendId = data['friendId'];
    Future<String> getProfile()
    async {
      return await Firestore.instance.collection('Ravan').document(data['friendId']).get().then((value) => value.data['image']);
    }
    getName();
//    print(friendId);

     if((currentId.hashCode - friendId.hashCode)>0)
       {
         msgId = currentId.hashCode - friendId.hashCode;
      //   print(msgId);
       }
     else
       {
         msgId = friendId.hashCode - currentId.hashCode ;
        // print(msgId);
       }
     return SafeArea(
       child: Scaffold(
         body: !isUploading ?  Container(
           child: Column(
             children: <Widget>[
               Container(
                 color: Colors.black.withOpacity(0.8),
                 child: ClipRRect(
                   borderRadius: BorderRadius.only(bottomRight: Radius.circular(30) , bottomLeft: Radius.circular(30)),
                   child: Padding(
                     padding: const EdgeInsets.fromLTRB(5, 3 , 5 ,5),
                     child: Container(
                       decoration: BoxDecoration(
                           gradient: LinearGradient(
                               colors: [Colors.lightBlue, Colors.deepPurple]
                             //colors: [Colors.deepOrangeAccent , Colors.orange]
                           )
                       ),
                       height: 50,
                       child: Center(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             CircleAvatar(
                                 backgroundColor: Colors.white,
                                 radius: 20,
                                 child:
                                 FutureBuilder(
                                     future: getProfile(),
                                     builder:(context ,AsyncSnapshot<String> snapshot) {
                                       if(snapshot.hasData)
                                       {
                                         return ClipOval(
                                           child: SizedBox(
                                             height: 40,
                                             width: 40,
                                             child: Image(
                                                 image: CachedNetworkImageProvider(snapshot.data),
                                                 //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                                 fit: BoxFit.cover
                                             ),
                                           ),
                                         );
                                       }
                                       else
                                       {
                                         return CircleAvatar(
                                           backgroundColor: Colors.white,
                                           radius: 20,
                                         );
                                       }
                                     }
                                 )
                             ),
                             SizedBox(width: 8,),
                             Text(friendName,
                               style : TextStyle(
                                 // fontFamily: 'Pacifico',
                                   fontSize: 20.0,
                                   color: Colors.white
                               ),
                             ),
                             // InkWell(
                             //     onTap: (){
                             //       scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 2000), curve: Curves.easeOutQuint);
                             //     },
                                // child: Icon(Icons.arrow_downward ,size: 20, color: Colors.white,))
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
               Expanded(
                 child: Container(
                   color: Colors.black.withOpacity(0.8),
                   //color: Color(0xffffe4b5),
                   child: StreamBuilder(
                       stream: Firestore.instance.collection('Ravan').document(currentId.toString()).
                       collection(msgId.toString()).orderBy('timestamp'.toString() , descending : false).snapshots(),
                       builder: (context, snapshot) {
                             return ListView.builder(
                               itemBuilder: (context, index) =>
                                   _buildMsg(
                                       context, snapshot.data.documents[index]),
                               controller: scrollController,
                               itemCount: snapshot.data.documents.length,
                               //              itemExtent: 80.0,
                             );
                       }
                   ),
                   height: MediaQuery.of(context).size.height,
                 ),
               ),
               Align(
                 alignment: Alignment.bottomCenter,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                     child: Row(
                       children: <Widget>[
                         InkWell(
                           onTap: (){
                             getImage();
                           },
                           child: Container(
                             height: 50,
                             child: Image(image: AssetImage('assets/gallery_icon_1.jfif'),),
                           ),
                         ),
                         Expanded(
                           child: TextField(
                             controller: myController,
                             autofocus: true,
                             keyboardType: TextInputType.multiline,
                             maxLines: null,
                             decoration: InputDecoration(
                               filled: true,
                               focusColor: Colors.purple,
                               hoverColor: Colors.red,
                               hintText: "Type Message",
                               fillColor: Colors.white,

                               border : OutlineInputBorder(),


                               enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(6),
                                   borderSide: BorderSide(color: Colors.blueGrey,width: 2)
                               ),
                               focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                               ),
                             ),
                             onChanged : (val) {
                               msg = val;
                             },

                             onSubmitted: (String str){
                               myController.clear();
                             },

                           ),
                         ),
                         SizedBox(width: 4,),
                         InkWell(
                           onTap: (){
                             myController.clear();
                             scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 20), curve: Curves.easeOutQuint);
                             sendAndRetrieveMessage(token, msg , currentName);
                             print(msg);
                             Firestore.instance.collection('Ravan').document(currentId).collection(msgId.toString()).add({
                               'msg' : msg,
                               'sent' : true,
                               'received' : false,
                               'timestamp' : DateTime.now().millisecondsSinceEpoch
                             });

                             Firestore.instance.collection('Ravan').document(currentId).collection('MsgBox').document(friendId).setData({
                               'Id' : friendId,
                               'Pic' : friendPic,
                               'msg' : msg ,
                               'name' : friendName,
                               'timestamp' : DateTime.now().millisecondsSinceEpoch
                             });

                             Firestore.instance.collection('Ravan').document(friendId).collection('MsgBox').document(currentId).setData({
                               'Id' : currentId,
                               'Pic' : currentPic,
                               'msg' : msg ,
                               'name' : currentName,
                               'timestamp' : DateTime.now().millisecondsSinceEpoch
                             });

                             Firestore.instance.collection('Ravan').document(friendId).collection(msgId.toString()).add({
                               'msg' : msg,
                               'received' : true,
                               'sent' : false ,
                               'timestamp' : DateTime.now().millisecondsSinceEpoch
                             });
                           },
                           child: CircleAvatar(
                             // backgroundColor: Color(0xff00ffff),
                               backgroundColor:  Color(0xff6495ed),
                               radius: 25,
                               child:  Image(
                                 height: 40,
                                 width: 40,
                                 image: AssetImage("assets/send_icon.png"),
                               )
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ) : Container(
           color: Colors.black,
           child: Center(
             child: CircularProgressIndicator(
               backgroundColor: Colors.orange,
             ),
           ),
         ),
       ),
     );
  }
}
