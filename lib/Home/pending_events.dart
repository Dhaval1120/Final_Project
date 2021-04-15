import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:obvio/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:obvio/Utils/TimeConversion.dart';
import 'package:obvio/Utils/theme_colors.dart';

class PendingEvents extends StatefulWidget {
  @override
  _PendingEventsState createState() => _PendingEventsState();
}

class _PendingEventsState extends State<PendingEvents> {

  int month = 0;
  String userId = '';
  List events = List();
  bool isAdmin = false;
  String type , subType = '';
  getEvents () async{
    if(events.isNotEmpty)
    {
      setState(() {
        events.clear();
      });
    }
    print("if ");
    Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).getDocuments().then((value) {
      value.documents.forEach((element) {
        setState(() {
           if(element['isPending'])
             {
               events.add(element);
             }
          print("time Month is ${DateTime.parse(element['startdate']).toLocal().month}");
        });
      });
    });
  }

  getByFilter() async{
    if(events.isNotEmpty)
    {
      setState(() {
        events.clear();
      });
    }
    Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).where(type , isEqualTo: subType).getDocuments().then((value) {
      if(value.documents.isNotEmpty)
      {
        value.documents.forEach((element) {
          setState(() {
            events.add(element);
          });
        });
        // Navigator.pop(context);
      }
      else{
        //Navigator.pop(context);
      }
    });
  }

  getUserData()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('Ravan').document(user.uid).get().then((value) {
      setState(() {
        isAdmin = value['admin'];
      });
      print(" isAdmin $isAdmin");
    });
    setState(() {
      userId = user.uid;
    });
  }

  @override
  void initState() {
    getUserData();
    getEvents();
    // TODO: implement initState
    super.initState();
  }

  dialogFilter() {
    return showCupertinoDialog(barrierDismissible : true , context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Container(
          //color: Colors.pinkAccent,
          height: MediaQuery.of(context).size.height/2,
          child: Container(
            color: Colors.pinkAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Chip(
                  label: Text(" Department "),
                  backgroundColor: Colors.white,
                ),
                Wrap(
                  spacing: 5,
                  children: [
                    InkWell(onTap:(){
                      setState(() {
                        type = "department";
                        subType = "Computer";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text("Computer"),backgroundColor: Colors.white,)),
                    InkWell(onTap:(){
                      setState(() {
                        type = "department";
                        subType = "IT";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text('IT'),backgroundColor: Colors.white,)),
                    InkWell(onTap:(){
                      setState(() {
                        type = "department";
                        subType = "Electrical";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text("Electrical"),backgroundColor: Colors.white,)),
                    InkWell(onTap : (){
                      setState(() {
                        type = "department";
                        subType = "EC";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text("EC"),backgroundColor: Colors.white,)),
                    InkWell(onTap : (){
                      setState(() {
                        type = "department";
                        subType = "Chemical";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label :Text("Chemical"),backgroundColor: Colors.white,))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(height: 3, color: Colors.white,),
                ),
                Chip(label: Text(" Level "),backgroundColor: Colors.white,),
                Wrap(
                  spacing: 5,
                  children: [
                    InkWell(onTap : (){
                      setState(() {
                        type = "level";
                        subType = "National";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text("National"),backgroundColor: Colors.white,)),
                    InkWell(onTap :(){
                      setState(() {
                        type = "level";
                        subType = "State";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text('State'),backgroundColor: Colors.white,)),
                    InkWell(onTap : (){
                      setState(() {
                        type = "level";
                        subType = "College";
                        Navigator.pop(context);
                        getByFilter();
                      });
                    },child: Chip(label: Text("College"),backgroundColor: Colors.white,)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  Widget _buildEventList(BuildContext context,DocumentSnapshot snapshot)
  {
    print(' time is ${TimeConvertEvents(snapshot.data['timeStamp'])}');

    Future<String> getProfile()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['currentId']).get().then((value) => value.data['image']);
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 300
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 2, bottom: 3),
        child: Material(
          color: Colors.white,
          elevation: 5.0,
          shadowColor: Colors.orangeAccent,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/eventDescription', arguments: {
                    'event_id' : snapshot.documentID,
                    'isRegistered' : false,
                    'isAdmin' : true,
                  }
                  ).then((value)
                  {
                    setState(() {
                      getEvents();
                    });
                  });
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
                          SizedBox(width: 5,),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: FutureBuilder(
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

                          SizedBox(width : 5) ,

                          Container(
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(snapshot['currentName'],
                                    style: TextStyle(
                                      //fontFamily: 'Pacifico',
                                      fontSize: 16.0,
                                      //      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )
                                ),
                                // SizedBox(width: 1.0,),

                                Text(' added an event.',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      //fontFamily: 'Pacifico',
                                      fontSize: 15.0,
                                      //    fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )
                                ),
                              ],
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.fromLTRB(100, 0, 5, 0),
                            child: InkWell(
                              child: Icon(
                                Icons.menu,
                                color: Colors.orange,
                                size: 25,
                              ),
                            ),
                          )*/
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.red,),
                          SizedBox(width: 9,),

                          Text(TimeConvertEvents(snapshot.data['timeStamp'],) ,style: TextStyle(
                              color: Colors.black38
                          ),
                          )
                        ],
                      ),

                    ),

                    SizedBox(height: 3),

                    Container(
                      // decoration: BoxDecoration(
                      //   border:  Border.all(color: Colors.blueGrey)
                      // ),
                      //height: ,
                      child: Text(snapshot['about'],style: TextStyle(
                        fontSize: 16,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height : 9),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orangeAccent ,width: 5),
                            color: Colors.blueAccent,
                            borderRadius : BorderRadius.circular(5)
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 200.0,
                        child: Image(

                          image: AssetImage("assets/events.jpg"),
                          // image : AssetImage('assets/${images[index]}'),
                          height: 50.0,
                          width: 50.0,
                          fit: BoxFit.cover,
                        ),


                      ),
                    ),
                    SizedBox(height:5),

                    Divider(
                      color: Colors.black12,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }


  /*
   Container(
                // height: 250 , width: MediaQuery.of(context).size.width - 50,
                 child: Wrap(
                   alignment: WrapAlignment.spaceEvenly,
                   direction: Axis.horizontal,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             month = 1;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Jan', style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             month = 2;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Feb',style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             month = 3;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('March',style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             month = 4 ;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('April',style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             month = 5;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('May',style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 6;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('June',style: TextStyle(color: Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 7;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('July',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 8;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Aug',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 9;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Sept',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 10;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Oct',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 12;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Nov',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 12;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Container(color: Color(0xff9370db),child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('Dec',style: TextStyle(color :Colors.white),),
                         )),
                       ),
                     ),


                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap : (){
                           setState(() {
                             month = 0;
                             getEvents();
                             Navigator.pop(context);
                           });
                         },
                         child: Center(
                           child: Container(color: Colors.pinkAccent,child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('ALL',style: TextStyle(color :Colors.white),),
                           )),
                         ),
                       ),
                     )
                   ]
                 ),
               ),
   */
  String dropdownValue = 'One';

  dynamic showFilterItems()
  {

    showModalBottomSheet(
        enableDrag: true,
        backgroundColor: Colors.redAccent,
        context: context,
        builder: (context) => Container(
          child: ListView(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 200
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Month' ,style: TextStyle(color: Colors.white ,height: 20),),

                  ],
                ),
                //   color: Colors.blue,
                // height: 200,
              ),
              Container(
                color: Colors.indigo,
                height: 200,
              ),
              Container(
                color:Colors.blueAccent,
                height: 200,
              ),
            ],
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body : Stack(
          children: [
            Column(
              children: <Widget>[
                ClipRRect(
                    child: Material(
                      elevation: 20,
                      child: Container(
                        // decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //         colors: [Colors.deepOrangeAccent , Colors.orange]
                        //     )
                        // ),
                          color: appBarColor,
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            title: Text(" Events ", style:  TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              //fontFamily: "Lobster"
                            ),),
                            trailing: InkWell(
                                onTap: (){dialogFilter();},
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.filter_none_sharp , color: Colors.black,))),
                          )
                        //color: Colors.redAccent
                      ),
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
                ),
                events.isNotEmpty ? Expanded(
                  child: Container(
                      child: StreamBuilder(
                          stream : Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).snapshots(),
                          builder : (context,snapshot)
                          {

                            if(!snapshot.hasData) return Container();
                            return ListView.builder(
                              itemBuilder: (context,index) =>
                                  _buildEventList(context, events[index]),//snapshot.data.documents[index]),
                              itemCount: events.length,
                              //              itemExtent: 80.0,
                            );
                          })
                  ),
                ) :  Expanded(
                  child: Center(child: Container(child: Center(child: Text(" No Events ! "))),
                  ),
                )
              ],
            ),
          ],
        ),
        //
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: Colors.redAccent,
        //     child: InkWell(
        //       onTap: () => {
        //         Navigator.pushNamed(context , '/addEvent' ).then((value) {
        //           setState(() {
        //             print(" I am back");
        //             getEvents();
        //           });
        //         })},
        //       child: Icon(
        //         Icons.add,
        //         size: 35,
        //       ),
        //     )
        // ),
      ),
    );
  }
}

showAlert(BuildContext context , int docId) {
  DatabaseService dbService = new DatabaseService();
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context)
      {
        return AlertDialog(
          content: Text("Are u sure u want to Delete ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Delete"),
              onPressed: () => dbService.deleteEvent(docId).then((value) => Navigator.pop(context)),
            ),
            FlatButton(
              child : Text("Cancel"),
              onPressed:() => Navigator.pop(context),
            )
          ],
        );
      }
  );
}

