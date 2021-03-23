import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:intl/intl.dart';
import 'package:obvio/Design/background.dart';

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


    Future<String> getProfile()
    async {

      return await Firestore.instance.collection('Ravan').document(snapshot.data['userId']).get().then((value) => value.data['image']);

    }

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
              SizedBox(width: 10,),
              Text(snapshot.data['name'],style: TextStyle(
                fontSize: 16,
                     // fontFamily: 'Sriracha',
                     // color: Colors.deepPurple,
                      //  fontWeight:FontWeight.bold
                        )
                    ),
              
              SizedBox(width :4 ),
              Expanded(
                child: Text("Liked Your photo." ,style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    //fontFamily: 'Sriracha',
                    color: Colors.black
                )
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
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Notifications",
            style : TextStyle(
             // fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(child: Icon(Icons.person_add , size: 28,),hoverColor: Colors.blue,highlightColor: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/requests')),
            )
          ],
        ),

        body: Stack(
          children: <Widget>[
           /* Container(
              child: Background(),
            ),*/
            StreamBuilder(
                stream : Firestore.instance.collection("Ravan").document(uid).
                collection('Notifications').orderBy('timestamp' ,descending: true) .snapshots(),
                builder: (context,snapshot)
                {
                  if(!snapshot.hasData) return Loading();
                  else if(snapshot.data.documents.length < 1){
                    return Center(
                        child: Text("No Records" ,style: TextStyle(color: Colors.black,fontSize: 20),
                        )
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context , index) => buildNotifications(context ,snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }

            ),
          ],
        )
      ),
    );
  }
}
