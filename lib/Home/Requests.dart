import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Home/SearchedUser.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Utils/TimeConversion.dart';


class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  var currentId , currentName;
  var userProfilePic;
  List requests = List();
  void setId () async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = user.uid;
      print(currentId);
      Firestore.instance.collection('Ravan').document(currentId).get().then((value) {
        setState(() {
          currentName = value['name'];
        });
      });
      getRequests();
    });

  }

  getRequests()async {
    if (requests.isNotEmpty)
    {
      setState(() {
        requests.clear();
      });
    }
    Firestore.instance.collection('Ravan').document(currentId).collection("Requests").getDocuments().then((value) {
      value.documents.forEach((element) {
        setState(() {
          requests.add(element);
          print(" len is ${requests.length}");
        });
      });
    });
  }
  var requestedName;

  Future<void> setUser(DocumentSnapshot snapshot , String requestedId) async{
    Firestore.instance.collection('Ravan').document(snapshot['docId']).get().then((value)  {
      setState(() {
        requestedName = value['name'];
        userProfilePic = value['image'];
      });
    });

  }
  var requestedId;


  Widget buildRequestList(BuildContext context , DocumentSnapshot snapshot)
  {
    var id = snapshot.documentID;
    requestedId = snapshot["docId"];
    print(" I am Name ${snapshot.data['name']}");
    Future<String> getProfileName()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) {
        print(" Name is ${value['name']}");
        return value.data['name'];
      });
    }
    Future<String> getProfilePic()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) {
       // print(" Name is ${value['name']}");
        return value.data['image'];
      });
    }
    //print(id);
    //print(requestedId);
   setUser(snapshot , requestedId);

    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //SizedBox(width: 10,),
                    SizedBox(width: 5,),
                    InkWell(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent,
                        child:FutureBuilder(
                        future: getProfilePic(),
                          builder: (context , asyncSnap){
                             if(asyncSnap.hasData && asyncSnap != null)
                               {
                                 return ClipOval(
                                   child: SizedBox(
                                     height: 40,
                                     width: 40,
                                     child: Image(
                                       image: NetworkImage(asyncSnap.data),
                                       fit: BoxFit.cover,
                                     ),
                                   ),
                                 );
                               }
                             return Container();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 3,),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  FutureBuilder(
                                  future: getProfileName(),
                                  builder: (context , asyncSnap)
                                  {
                                    if(asyncSnap.hasData && asyncSnap != null)
                                    {
                                      return  InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext contetx){
                                            return SearchedUser(searchedId: snapshot.data['docId'],name: asyncSnap.data,);
                                          }));
                                        },
                                        child: Text(asyncSnap.data,
                                            style: TextStyle(
                                                fontSize: 16,
                                                // fontWeight: FontWeight.bold,
                                                //fontFamily: 'Sriracha',
                                                color: Colors.black
                                            )),
                                      );
                                    }
                                    //  if(asyncSnap.connectionState != ConnectionState.waiting)
                                    //    {
                                    //      return  Text(asyncSnap.data,
                                    //          style: TextStyle(
                                    //              fontSize: 16,
                                    //              // fontWeight: FontWeight.bold,
                                    //              //fontFamily: 'Sriracha',
                                    //              color: Colors.black
                                    //          ));
                                    //    }
                                    return Container();
                                  },
                                ),
                                  Text(" sent you a request." ,style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                      //fontFamily: 'Sriracha',
                                      color: Colors.black
                                  )
                                  ),
                                ],
                              ),
                            ),
                            Text(TimeConvert(snapshot['timestamp']),style: TextStyle(color: Colors.black38),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Align(
                    alignment: Alignment.topLeft,
                    child:Row(
                      children: <Widget>[
                        //SizedBox(width: 50),
                        RaisedButton(
                          onPressed : () {
                            Firestore.instance.collection('Ravan').document(requestedId).collection('Following').document(currentId).setData({
                              'docId' : currentId,
                              'name' : currentName,
                            }).then((value) {

                              Firestore.instance.collection('Ravan').document(currentId).
                              collection('Requests').document(snapshot.documentID).delete();

                              Firestore.instance.collection('Ravan').document(requestedId).
                              collection('Requested').document(currentId).delete();


                              Firestore.instance.collection('Ravan').document(requestedId).
                              collection('Requested').document(currentId).delete();

                              Firestore.instance.collection('Ravan').document(currentId).collection('Followers').document(requestedId).setData({
                                'docId' : requestedId,
                                'name' : snapshot.data["name"],
                              });

                              getRequests();
                            }
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          ),
                          elevation: 6,
                          highlightElevation: 8,
                          highlightColor: Colors.purple,
                          color: Colors.purple,
                          focusColor: Colors.blue,
                          child:  Text('Accept', style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),),

                        ),
                        SizedBox(width: 5,),

                        RaisedButton(
                          color: Colors.blue,
                          elevation: 5,
                          onPressed: (){
                            Firestore.instance.collection('Ravan').document(currentId).
                            collection('Requests').document(snapshot.documentID).delete().then((value) {
                              getRequests();
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child:  Text('Reject', style: TextStyle(
                              fontSize: 15 ,
                              color: Colors.white
                          ),),

                        ),
                      ],
                    )
                )
              ],
            ),
          )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setId();
  }

  @override
  Widget build(BuildContext context) {


      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
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
                          title: Text(" Requests ", style:  TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            //fontFamily: "Lobster"
                          ),),
                      )
                    //color: Colors.redAccent
                  ),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
            ),
            requests.length != 0 ? Expanded(
              child: Container(
                child: ListView.builder(itemBuilder: (BuildContext context , int index){
                  return buildRequestList(context, requests[index]);
                },itemCount: requests.length,),
              ),
            ) : Expanded(child: Center(child: Text('No Requests'),))
          ],
        )
      ),
    );
  }
}
