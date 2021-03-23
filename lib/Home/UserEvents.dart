import 'package:flutter/cupertino.dart';
import 'package:obvio/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserEvents extends StatefulWidget {
  @override
  _UserEventsState createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {

  int month = 0;
  List events = List();
  getEvents () async{
    // Firestore.instance.collection('EventDetails').snapshots().forEach((element) {
    //   setState(() {
    //     events.add(element);
    //   });
    // }).then((value){
    //   print(" len ${events.length}");
    // });
    if(events.isNotEmpty)
      {
        setState(() {
          events.clear();
        });
      }
    if(month == 0)
      {
        print("if ");
        Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).getDocuments().then((value) {
          value.documents.forEach((element) {
            setState(() {
              events.add(element);
              print("time Month is ${DateTime.parse(element['startdate']).toLocal().month}");
            });
          });
        });
      }
    else
      {
        print(" Else month $month");
        Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).getDocuments().then((value) {
          value.documents.forEach((element) {
            if(DateTime.parse(element['startdate']).toLocal().month == month)
              {
                setState(() {
                  events.add(element);
                  print("time Month ${DateTime.parse(element['timeStamp']).toLocal().month}");
                });
              }
          });
        });
      }
  }
  @override
  void initState() {
    getEvents();
    // TODO: implement initState
    super.initState();
  }


  Widget _buildEventList(BuildContext context,DocumentSnapshot snapshot)
  {
    Future<String> getProfile()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['currentId']).get().then((value) => value.data['image']);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 370
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

                  Navigator.pushNamed(
                      context, '/eventDescription', arguments: {

                    'event_id' : snapshot.documentID,
                    /*'event_name': snapshot['event_name'],
                        'host_name': snapshot['host_name'],
                        'location' : snapshot['location'],
                        'startdate': snapshot['startdate'],
                        'enddate' : snapshot['enddate'],
                        'time': snapshot['time'],*/

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
                                              fit: BoxFit.contain

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

                          SizedBox(width : 2) ,

                          Text(snapshot['currentName'],
                              style: TextStyle(
                                //fontFamily: 'Pacifico',
                                fontSize: 16.0,
                                //      fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )
                          ),
                          SizedBox(width: 1.0,),

                          Text('added an event.',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //fontFamily: 'Pacifico',
                                fontSize: 15.0,
                                //    fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )
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
                        ],
                      ),

                    ),

                    SizedBox(height: 2),

                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(
                        //   border:  Border.all(color: Colors.blueGrey)
                        // ),
                        height: 80,
                        child: Text(snapshot['about'],style: TextStyle(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    SizedBox(height : 2),
                    Container(
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
                    SizedBox(height:5),

                    Divider(
                      color: Colors.black12,
                      thickness: 2,
                    ),
                    Container(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Container(

                              child :  IconButton(icon: Icon(Icons.comment) , iconSize: 23,onPressed: (){},color: Colors.blueGrey,)

                          ),

                          Container(

                              child :  IconButton(icon: Icon(Icons.share) , iconSize: 23,onPressed: (){},color: Colors.deepPurpleAccent,)

                          ),
                          Container(
                              child :  IconButton(icon: Icon(Icons.star) , iconSize: 23,onPressed: (){},color : Colors.purpleAccent)
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }


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

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        brightness: Brightness.dark,
        titleSpacing: 2.0,
        title: Text("Events",
          style : TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
         IconButton(
           onPressed: (){

             showDialog(context: context,builder: (context) => AlertDialog(
               scrollable: true,
               title: Container(
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
             //  backgroundColor: Colors.amber,
             ));
 //            showFilterItems() ;
           },
           icon : Icon(Icons.filter_list),iconSize: 25,color: Colors.white,)
        ],
        centerTitle: true,
        backgroundColor: Color(0xff09203f),

      ),


      body : Column(
        children: <Widget>[
          /*Center(
            child: Container(

              height: 50,
              child :DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
               )
              ),
          ),*/
          Expanded(
            child: Container(
              child: StreamBuilder(
                  stream : Firestore.instance.collection('EventDetails').orderBy('timeStamp' , descending: true).snapshots(),
                  builder : (context,snapshot)
                  {
                    if(!snapshot.hasData) return Loading();
                    return ListView.builder(
                      itemBuilder: (context,index) =>
                          _buildEventList(context, events[index]),//snapshot.data.documents[index]),
                      itemCount: events.length,
  //              itemExtent: 80.0,
                    );
                  })
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffcd5c5c),
          child: InkWell(
            onTap: () => {
              Navigator.pushNamed(context , '/addEvent' ).then((value) {
                setState(() {
                  print(" I am back");
                  getEvents();
                });
              })},
            child: Icon(
              Icons.add,
              size: 35,
            ),
          )
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

