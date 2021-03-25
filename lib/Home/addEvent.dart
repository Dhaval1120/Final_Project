import 'package:flutter/material.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with SingleTickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();
  String event_name = '';
  String location = '';
  String startdate,enddate = '';
  String time = '';
  String about = '';
  String host_name = '';
  int id ;
  bool isOpenDropDown = false;
  var randomNumber = new Random();
  AnimationController _animationController;
  List<String> department = ['Computer' , "IT" , "Electrical" , "EC" , "Chemical"];
  String selectedDepartment;
  List<String> level = ["National" , "State" , " College"];
  String selectedLevel;
  TextEditingController startdateController = new TextEditingController();
  TextEditingController enddateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

  DatabaseService dbServices = DatabaseService();

  String currentUser ,currentId , currentProfile;
  Future<Widget> setName()
  async
  {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      Firestore.instance.collection('Ravan').document(user.uid).get().then((value) =>
      {
        currentUser = value["name"],
        currentId = user.uid,
        currentProfile = value["image"],
        //print(currentProfile),
       }
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    setName();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   elevation: 8.0,
          //   brightness: Brightness.dark,
          //   titleSpacing: 2.0,
          //   title: Text("Event",
          //     style : TextStyle(
          //       fontFamily: 'Pacifico',
          //       fontSize: 20.0,
          //     ),
          //   ),
          //   centerTitle: true,
          //   backgroundColor: Color(0xff09203f),
          // ),

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
                          title: Text(" Add Event ", style:  TextStyle(
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
              Expanded(
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical : 20.0 , horizontal: 20.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          children: <Widget>[
                            SizedBox(height:20,),
                              TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusColor: Colors.purple,
                                  hoverColor: Colors.red,
                                  fillColor: Colors.white,
                                  border : OutlineInputBorder(),
                                  labelText : " Event Name",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white,width: 2)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,width: 2)
                                  ),
                                ),
                                onChanged: (val)
                                {
                                  event_name = val;
                                },
                            ),


                            SizedBox(height: 15,),
                            TextField(

                              autofocus: true,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.purple,
                                hoverColor: Colors.red,
                                fillColor: Colors.white,

                                border : OutlineInputBorder(),
                                labelText : "Host Name",

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                              ),
                              onChanged: (val)
                              {
                                host_name = val;
                              },

                            ),
                            SizedBox(
                              height : 15,
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                                child: DropdownButton(
                                   underline: Container(),
                                    onChanged: (value){
                                      setState(() {
                                        selectedDepartment = value;
                                      });
                                    },
                                    value: selectedDepartment,
                                    icon : Icon(Icons.arrow_drop_down_sharp ,color: Colors.indigo,),
                                    hint : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Select Department" , ),
                                    ),
                                    items: department.map((department) {
                                  return DropdownMenuItem(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(child: Text(department)),
                                  ), value: department,);
                                }).toList()),
                              ),
                            ),
                            SizedBox(
                              height : 15,
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                                child: DropdownButton(
                                    underline: Container(),
                                    onChanged: (value){
                                      setState(() {
                                        selectedLevel = value;
                                      });
                                    },
                                    value: selectedLevel,
                                    icon : Icon(Icons.arrow_drop_down_sharp ,color: Colors.indigo,),
                                    hint : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Select Level" , ),
                                    ),
                                    items: level.map((e) {
                                      return DropdownMenuItem(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(child: Text(e)),
                                      ), value: e,);
                                    }).toList()),
                              ),
                            ),
                            SizedBox(
                              height : 15,
                            ),

                            TextFormField(

                              autofocus: true,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.purple,
                                hoverColor: Colors.red,
                                fillColor: Colors.white,

                                border : OutlineInputBorder(),
                                labelText : "Location",

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                              ),
                              onChanged: (val)
                              {
                                location = val;
                              },

                            ),

                            SizedBox (height : 15),


                            TextFormField(

                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.purple,
                                hoverColor: Colors.red,
                                fillColor: Colors.white,


                                border : OutlineInputBorder(),
                                labelText : "About",

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                              ),
                              onChanged: (val)
                              {
                                about = val;
                              },

                            ),

                            SizedBox (height : 15),

                            TextFormField(

                              controller: startdateController,
                                   autofocus: true,
                                   decoration: InputDecoration(
                                     filled: true,
                                     focusColor: Colors.purple,
                                     hoverColor: Colors.red,
                                     fillColor: Colors.white,

                                     border : OutlineInputBorder(),
                                     labelText : "Start Date ",

                                     enabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: Colors.white,width: 2)
                                     ),
                                     focusedBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: Colors.red,width: 2)
                                     ),
                                   ),
                                   onTap: () async {

                                     var dates;

                                     var day,month ,year;

                                     showDatePicker(context: context, initialDate: DateTime.now(),
                                         firstDate: DateTime.now(),
                                         lastDate: DateTime(2022)).then((value) {

                                           var showdate;
                                           setState(() {
                                             day = value.day.toString();
                                             month = value.month.toString();
                                             year = value.year.toString();
                                             dates = value.toString().split('-');
                                             print(dates[0]);print(dates[1]);

                                             showdate = DateFormat.yMMMEd().format(value).toString();
                                             //startdate =  year + "-" + month + "-" + day ;//+ "-" + dates[2];
                                             startdate = value.toUtc().toString();
                                             startdateController.value = TextEditingValue(text : showdate);
                                           });
                                           });
                                     },
                            ),

                            SizedBox(
                              height : 15,
                            ),

                            TextFormField(

                              controller: enddateController,
                              autofocus: true,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.purple,
                                hoverColor: Colors.red,
                                fillColor: Colors.white,

                                border : OutlineInputBorder(),
                                labelText : " End Date ",

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                              ),
                              onTap: () async {

                                var dates;

                                var day,month ,year;

                                showDatePicker(context: context, initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2022)).then((value) {
                                      var showdate;
                                   setState(() {
                                    day = value.day.toString();
                                    month = value.month.toString();
                                    year = value.year.toString();
                                    dates = value.toString().split('-');
                                    print(dates[0]);print(dates[1]);
                                    showdate = DateFormat.yMMMEd().format(value).toString();
                                    enddate = value.toUtc().toString();
                                    enddateController.value = TextEditingValue(text :showdate);
                                  });
                                });
                              },
                            ),

                            SizedBox(
                              height : 15,
                            ),

                            TextField(



                                controller: timeController,
                                onTap: () async{

                                  var hours , minutes;

                                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){

                                   setState(() {

                                     hours = value.hour.toString();
                                     print(hours);
                                     minutes = value.minute.toString();
                                     time  = hours + ":" + minutes;
                                     print(time);
                                     timeController.value = TextEditingValue(text: time);
                                   });});
                                },
                                autofocus: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusColor: Colors.purple,
                                  hoverColor: Colors.red,
                                  fillColor: Colors.white,

                                  border : OutlineInputBorder(),
                                  labelText : " Time ",

                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white,width: 2)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,width: 2)
                                  ),
                                ),
                                onChanged: (val)
                                {
                                  time = val;
                                },

                              ),
                            SizedBox(
                              height : 15,
                            ),
                            Align(
                              alignment : Alignment.bottomCenter,
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal : 50 , vertical:  5),
                                  color : Colors.deepOrangeAccent,
                                  hoverColor: Colors.cyan,
                                  elevation: 3.0,
                                  splashColor: Colors.purple,
                                  child: Text("Add",
                                      style : TextStyle(
                                          color : Colors.white,
                                          fontSize: 20
                                      )

                                  ),
                                  autofocus: true,
                                  onPressed: () async {

                                    id = randomNumber.nextInt(100000);

                                    print(id);

                                    dynamic re = dbServices.addEventToUserFirebase(event_name,host_name,location,startdate,enddate ,about,time,id ,currentId , currentUser , selectedDepartment ,selectedLevel);
                                    if(re == null)
                                      {
                                        print("cannot add event");
                                      }
                                    Navigator.pop(context);
                                  }
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),
              ),


            ],)

      ),
    );
  }
}
