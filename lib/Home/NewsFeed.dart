import 'package:flutter/material.dart';
import 'package:obvio/Home/userproperties.dart';
import 'package:provider/provider.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {


  final List<String> titles = ["L.D College is hosting a techfest"
    , "V.g.e.c is hosting a techfest"
    , "GIT is Hosting a state level Hackathon"
    , "L.j. College is hosting a seminar for Final Year Stusdnts"
  ];
  final List<Image> images = [
    Image.asset("assets/image1.jpg"),
    Image.asset("assets/image2.jpg"),
    Image.asset('assets/image3.jpg'),
    Image.asset('assets/image4.jpg')
  ];
  final List<String> subtitle = [
    " It will be hosted by the g.t.u.",
    " This is college level event to encourage students"
    ,
    " This Hcakathon is organized to find and develop new innovation skill in students"
    ,
    "It Will be hosted by industries Experts"
  ];
  final List<String> dates = [
    "14 - 3 - 20",
    "22  - 3 - 20",
    "02 - 4 20",
    " 15 - 04 -20"
  ];
  final List<String> time = [
    "10 A.M. to 12 P.M",
    "10 A.M. to 12 P.M",
    "10 A.M. to 12 P.M",
    "10 A.M. to 12 P.M"
  ];


  @override
  Widget build(BuildContext context) {
    //final eventlist = Provider.of<List<EventDetails>>(context);


   // eventlist.forEach((notifications) {});
      return Scaffold(
          backgroundColor: Colors.black,
          body: ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      /*gradient: LinearGradient(
                        colors: [
                          Color(0xffff512f),
                          Color(0xffdd2476)
                        ], //Color(0xff009fff) ,Color(0xffec2f4b)],

                        // begin : Alignment.topLeft,
                        //   end : Alignment.bottomRight
                      ),*/
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 400.0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Material(

                        color: Colors.white,
                        elevation: 14.0,
                        shadowColor: Colors.orangeAccent,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: InkWell(
                              onTap: () {
                                /*Navigator.pushNamed(
                                    context, '/eventDescription', arguments: {
                                  'images': '${images[index]}',
                                  'title': '${titles[index]}',
                                  'subtitle': '${subtitle[index]}',
                                  'dates': '${dates[index]}',
                                  'time': '${time[index]}',
                                });*/
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
                                        Text(' Dhaval Parmar ',
                                            style: TextStyle(
                                              fontFamily: 'Sriracha',
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )
                                        ),
                                        SizedBox(width: 3.0,),

                                        Text('uploaded a pic',
                                            style: TextStyle(
                                              fontFamily: 'Sriracha',
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            )
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
                                      height: 300.0,
                                      child:

                                      Container(
                                        decoration: BoxDecoration(
                                        //  color: Colors.blueAccent,
                                          border: Border.all(
                                            color: Colors.red,
                                            width : 4
                                          )
                                        ),
                                        child: Image(
                                         image: AssetImage("assets/shirley.jpg"),
                                         //  image : AssetImage('assets/${images[index]}'),

                                         // image: NetworkImage(''),
                                          height: 120.0,

                                          width: 50.0,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),

                                  Container(
                                    decoration: BoxDecoration(
                                      /*border: Border.all(
                                        color : Colors.deepPurpleAccent,
                                        width: 3

                                      )*/
                                    ),
                                   child : Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.thumb_up,
                                          size: 30,
                                          color: Colors.deepPurple,
                                          ),

                                            onPressed: null,

                                        ),

                                        IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.add_comment,
                                            color: Colors.red,
                                            size : 30),
                                            ),
                                        IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.comment,
                                              color: Colors.orangeAccent,
                                              size : 30),
                                        )

                                      ],
                                    )
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
            },
          )
      );
  }
}