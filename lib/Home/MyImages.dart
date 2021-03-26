import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyImages extends StatefulWidget {
  @override
  _MyImagesState createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {

  String uid;

  void setUserData()
  async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid;
      print(uid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }


  Widget _buildMyImages(BuildContext context, DocumentSnapshot snapshot) {


    Future<String> getProfile()
    async {

      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);

    }

    return Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500,

          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Material(
              color: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.orangeAccent,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: InkWell(
                    onTap: () {

                    },
                    splashColor: Colors.cyanAccent,
                    highlightColor: Colors.teal,

                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          //height : .0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal : 6.0 ,vertical : 5),
                                child: CircleAvatar(
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
                              ),

                              SizedBox(width: 3,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(snapshot['name']
                                      ,style : TextStyle(
                                        fontSize: 17,
//                                        fontFamily: "Sriracha",
                                        //  color: Colors.white
                                      ),),
                                  ),
                                ],
                              ),

                            ],
                          ),

                        ),

                        SizedBox(height: 2),

                        Expanded(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            //height: 300.0,
                            child:
                            Container(
                              decoration: BoxDecoration(
                                //  color: Colors.blueAccent,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data["image"],
                                imageBuilder: (context , imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      image : DecorationImage(
                                        image : imageProvider,
                                        fit : BoxFit.cover,
                                      )
                                  ),
                                ),
                                placeholder: (context , url) => Center(child: SpinKitDualRing(color: Colors.deepPurple,size: 60,)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Container(
                            decoration: BoxDecoration(
                            ),

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          centerTitle: true,
          backgroundColor: Color(0xff09203f),
        ),
        body : StreamBuilder(
            stream: Firestore.instance.collection('Ravan').document(uid).collection('MyImages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Loading();
              else if(snapshot.data.documents.length < 1){
                return Center(
                  child: Text("No Images to Show" , style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontFamily: 'Pacifico'
                  ),),
                );
              }
              return //Center(child: Text("Hello"));
              ListView.builder(
              itemBuilder: (context, index) =>
              _buildMyImages(
              context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              //              itemExtent: 80.0,
              );

            }
        ),
      ),
    );
  }
}
