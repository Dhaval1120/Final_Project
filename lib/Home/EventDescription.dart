import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Home/registerForEvent.dart';

class EventDesc extends StatefulWidget {
  @override
  _EventDescState createState() => _EventDescState();
}

class _EventDescState extends State<EventDesc> {

  String title;
  String about,event_name,host_name,location,startdate,enddate,time;
  String eventId;
  Future<void> getEventData(Map data)
  {
        eventId = data['event_id'];

        Firestore.instance.collection('EventDetails').document(eventId).get().then((value)  {
          setState(() {
            about = value['about'];
            event_name = value['event_name'];
            host_name = value['host_name'];
            location = value['location'];
            startdate = value['startdate'];
            enddate = value['enddate'];
            time = value['time'];
          });
        });
        
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getEventData();
  }

  @override
  Widget build(BuildContext context) {
    // String title;

    Map data = ModalRoute.of(context).settings.arguments;

    getEventData(data);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //String title = data.title as String;
    return Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("About",
            style : TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),
        ),

        body: data != null ? Stack(

          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child : Background(),
            ),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  color : Colors.white,
                  border : Border.all(
                      color: Colors.purple,
                      width : 4
                  ),
                  borderRadius: BorderRadius.circular(15),

                ),
                //   width : 350.0,
                //     height: (MediaQuery.of(context).size.height - 50),
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height:4,),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: Image(

                        image : AssetImage("assets/events.jpg"),
                      ),
                    ),

                    SizedBox(height: 10),
                    Divider(
                      thickness : 2,
                      indent: 25,
                      endIndent: 25,
                      color: Colors.deepPurpleAccent,
                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('About : ',
                                  style  : TextStyle(
                                    //  fontFamily: 'Pacifico',
//                                  fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                  child: about != null ? Text(about,
                                      style : TextStyle(
                                        //    fontFamily: 'Lobster',
                                        //                                    fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.blueAccent
                                      )
                                  ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height : 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('Event Name : ',
                                  style  : TextStyle(
                                    //  fontFamily: 'Pacifico',
//                                  fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                child: event_name != null ? Text(event_name,
                                    style : TextStyle(
                                      //    fontFamily: 'Lobster',
                                      //                                    fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.blueAccent
                                    )
                                ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height : 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('Host Name : ',
                                  style  : TextStyle(
                                    //                            fontWeight: FontWeight.bold,
                                    //fontFamily: 'Lobster',
                                    fontSize: 22.0,
                                    color : Colors.black,
                                  )
                              ),

                              SizedBox(width : 3),


                              Expanded(
                                child: host_name != null ? Text(host_name,
                                    style : TextStyle(
                                      //                              fontWeight: FontWeight.bold,
                                      //    fontFamily: 'Lobster',
                                        fontSize: 25.0,
                                        color : Colors.blueAccent
                                    )
                                ) : Container()
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox (height : 10),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('Location : ',
                                  style  : TextStyle(
                                    //fontFamily: 'Lobster',
                                    //                        fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                child: location != null ? Text(location,
                                    style : TextStyle(
                                      //            fontFamily: 'Lobster',
                                        fontSize: 20.0,
                                        //                          fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                    )
                                ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox (height : 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('Start Date : ',
                                  style  : TextStyle(
                                    //  fontFamily: 'Lobster',
                                    fontSize: 22.0,
                                    //                    fontWeight: FontWeight.bold,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                child: startdate != null  ? Text(startdate,
                                    style : TextStyle(
                                      //    fontFamily: 'Lobster',
                                        fontSize: 20.0,
                                        //                      fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                    )
                                ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SizedBox (height : 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('End Date : ',
                                  style  : TextStyle(
                                    //  fontFamily: 'Lobster',
                                    fontSize: 22.0,
                                    //                fontWeight: FontWeight.bold,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                child: enddate != null ? Text(enddate,
                                    style : TextStyle(
                                      //    fontFamily: 'Lobster',
                                        fontSize: 20.0,
                                        //                  fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                    )
                                ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox (height : 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            )
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text('Time : ',
                                  style  : TextStyle(
                                    //  fontFamily: 'Lobster',
                                    fontSize: 22.0,
                                    //            fontWeight: FontWeight.bold,
                                    color : Colors.black,
                                  )
                              ),
                              SizedBox(width: 5.0,),

                              Expanded(
                                child: time != null ? Text(time,
                                    style : TextStyle(
                                      //    fontFamily: 'Lobster',
                                        fontSize: 20.0,
                                        //              fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                    )
                                ) : Container()
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /*
                      Text(data['dates'],
                          style : TextStyle(
                              fontSize: 25.0,
                            color: Colors.purple
                          )
                      )*/

                    SizedBox(height : 10 ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment : Alignment.bottomCenter,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                          color : Color(0xff000080),
                          hoverColor: Colors.cyan,
                          elevation: 3.0,
                          splashColor: Colors.purple,
                          child: Text("REGISTER",
                              style : TextStyle(
                                  color : Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Lobster'
                              )

                          ),
                          autofocus: true,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EventRegistration(
                                eventId : data['event_id']
                            )));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            /*Align(
              alignment : Alignment.bottomCenter,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                color : Color(0xff000080),
                hoverColor: Colors.cyan,
                elevation: 3.0,
                splashColor: Colors.purple,
                child: Text("REGISTER",
                    style : TextStyle(
                        color : Colors.white,
                        fontSize: 20,
                        fontFamily: 'Lobster'
                    )

                ),
                autofocus: true,
                onPressed: (){},
              ),
            ),*/

          ],) : Container()
    );
  }
}
