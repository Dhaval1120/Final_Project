import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:intl/intl.dart';
import 'package:obvio/Design/background.dart';
import 'package:obvio/Utils/TimeConversion.dart';
import 'package:obvio/Utils/common_image_display_widget.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var uid;
  void setUserId() async{
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
   // print(DateTime.now().month);
   // print(DateFormat.jm().format(DateTime.now())

    setUserId();
  }
  Widget buildNotifications(BuildContext context, DocumentSnapshot snapshot) {
    String timeToDisplay = TimeConvert(DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']));
    print(" Date is ${DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp'])}");
    Future<String> getProfile()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['userId']).get().then((value) => value.data['image']);
    }
    print("Image Url is ${snapshot.data['timestamp']}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3 ,horizontal: 3),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(width: 10,),
              Text(snapshot.data['name'],style: TextStyle(
                fontSize: 16,
                     // fontFamily: 'Sriracha',
                     // color: Colors.deepPurple,
                //  fontWeight:FontWeight.bold
              ),overflow: TextOverflow.ellipsis,),
              SizedBox(width :4 ),
              Expanded(
                child: Text("Liked Your photo." ,style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    //fontFamily: 'Sriracha',
                    color: Colors.black
                ),
                ),
              ),
             // Text(timeToDisplay),
              // Container(
              //   color: Colors.black,
              //   height: 30,
              //   width: 30,
              // ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ImageDisplay(
                        imgUrl: snapshot.data['imgUrl'],
                      );
                    }));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image(
                        image : CachedNetworkImageProvider(snapshot.data['imgUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
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
                        title: Text(" Notifications ", style:  TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          //fontFamily: "Lobster"
                        ),),
                        trailing: InkWell(
                            child: ClipOval(
                              child: Material(
                                elevation: 20,
                                child: ClipOval(
                                  child: Container(
                                    child: CircleAvatar(
                                     backgroundColor: Colors.white,
                                    child: Icon(Icons.person_add , size: 28,)),
                                  ),
                                ),
                              ),
                            ),hoverColor: Colors.blue,highlightColor: Colors.red,
                         onTap: () => Navigator.pushNamed(context, '/requests'))
                      )
                    //color: Colors.redAccent
                  ),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream : Firestore.instance.collection("Ravan").document(uid).
                    collection('Notifications').orderBy('timestamp' ,descending: true) .snapshots(),
                    builder: (context,snapshot)
                    {
                      if(!snapshot.hasData) return Container();
                      else if(snapshot.data.documents.length < 1){
                        return Center(
                            child: Text("No Records" ,style: TextStyle(color: Colors.black,fontSize: 20),
                            )
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context , index) => buildNotifications(context ,snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                      );}

                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
