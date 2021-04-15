import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Home/registerForEvent.dart';
import 'package:obvio/Utils/theme_colors.dart';
class EventDesc extends StatefulWidget {
  @override
  _EventDescState createState() => _EventDescState();
}

class _EventDescState extends State<EventDesc> {

  String title;
  String about,event_name,host_name,location,startdate,enddate,time , department , level;
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
            department = value['department'];
            level = value['level'];
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
    return SafeArea(
      child: Scaffold(
          body: data != null ? Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
               ),

              Column(
                children: [
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
                              leading: InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back , color: Colors.white,),
                              ),
                              title: Text(" About ", style:  TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                //fontFamily: "Lobster"
                              ),),
                            )
                          //color: Colors.redAccent
                        ),
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
                  ),
                  Expanded(
                    child: Container(
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
                                          fontSize: 16.0,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                        child: about != null ? Text(about,
                                            style : TextStyle(
                                              //    fontFamily: 'Lobster',
                                              //                                    fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
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
                                          fontSize: 16.0,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                      child: event_name != null ? Text(event_name,
                                          style : TextStyle(
                                            //    fontFamily: 'Lobster',
                                            //                                    fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
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
                                          fontSize: 16.0,
                                          color : Colors.black,
                                        )
                                    ),

                                    SizedBox(width : 3),


                                    Expanded(
                                      child: host_name != null ? Text(host_name,
                                          style : TextStyle(
                                            //                              fontWeight: FontWeight.bold,
                                            //    fontFamily: 'Lobster',
                                              fontSize: 16.0,
                                              color : Colors.blueAccent
                                          )
                                      ) : Container()
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          department != null ?  Column(
                            children: [
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
                                        Text('Department : ',
                                            style  : TextStyle(
                                              //                            fontWeight: FontWeight.bold,
                                              //fontFamily: 'Lobster',
                                              fontSize: 16.0,
                                              color : Colors.black,
                                            )
                                        ),
                                        SizedBox(width : 3),
                                        Expanded(
                                            child:  department != null ? Text(department,
                                                style : TextStyle(
                                                  //                              fontWeight: FontWeight.bold,
                                                  //    fontFamily: 'Lobster',
                                                    fontSize: 16.0,
                                                    color : Colors.blueAccent
                                                )
                                            ) : Container()
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ): Container(),
                          level != null ?  Column(
                            children: [
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
                                        Text('Level : ',
                                            style  : TextStyle(
                                              //                            fontWeight: FontWeight.bold,
                                              //fontFamily: 'Lobster',
                                              fontSize: 16.0,
                                              color : Colors.black,
                                            )
                                        ),
                                        SizedBox(width : 3),
                                        Expanded(
                                            child:  level != null ? Text(level,
                                                style : TextStyle(
                                                  //                              fontWeight: FontWeight.bold,
                                                  //    fontFamily: 'Lobster',
                                                    fontSize: 16.0,
                                                    color : Colors.blueAccent
                                                )
                                            ) : Container()
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ) : Container(),
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
                                          fontSize: 16.0,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                      child: location != null ? Text(location,
                                          style : TextStyle(
                                            //            fontFamily: 'Lobster',
                                              fontSize: 16.0,
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
                                          fontSize: 16.0,
                                          //                    fontWeight: FontWeight.bold,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                      child: startdate != null  ? Text(startdate.split(' ').first,
                                          style : TextStyle(
                                            //    fontFamily: 'Lobster',
                                              fontSize: 16.0,
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
                                          fontSize: 16.0,
                                          //                fontWeight: FontWeight.bold,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                      child: enddate != null ? Text(enddate.split(" ").first,
                                          style : TextStyle(
                                            //    fontFamily: 'Lobster',
                                              fontSize: 16.0,
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
                                          fontSize: 16.0,
                                          //            fontWeight: FontWeight.bold,
                                          color : Colors.black,
                                        )
                                    ),
                                    SizedBox(width: 5.0,),

                                    Expanded(
                                      child: time != null ? Text(time,
                                          style : TextStyle(
                                            //    fontFamily: 'Lobster',
                                              fontSize: 16.0,
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
                          !data['isAdmin'] ?
                          !data['isRegistered'] ?  Padding(
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
                                     //   fontFamily: 'Lobster'
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
                          ) : Container() :  Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment : Alignment.bottomCenter,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                                color : Color(0xff000080),
                                hoverColor: Colors.cyan,
                                elevation: 3.0,
                                splashColor: Colors.purple,
                                child: Text("Accept",
                                    style : TextStyle(
                                        color : Colors.white,
                                        fontSize: 20,
                                        //fontFamily: 'Lobster'
                                    )

                                ),
                                autofocus: true,
                                onPressed: (){
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      content: Text(" Are You sure you want to accept the event Request ?"
                                      ),
                                      actions: [
                                        MaterialButton(color: Colors.deepPurple,onPressed: (){
                                          Firestore.instance.collection("EventDetails").document(eventId).updateData({
                                            'isPending' : false
                                          }).then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        },
                                          child: Text('Yes'),
                                        ),
                                        MaterialButton(color: Colors.red,onPressed: (){
                                          Navigator.pop(context);
                                        },child: Text('No' ,style: TextStyle(
                                            color: Colors.white
                                        ),),),
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
      ),
    );
  }
}
