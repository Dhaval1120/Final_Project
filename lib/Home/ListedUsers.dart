import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:obvio/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListedUsers extends StatefulWidget {
  @override
  _ListedUsersState createState() => _ListedUsersState();
}

class _ListedUsersState extends State<ListedUsers> {

  var currentId;

  bool currentUser;

  void setUserData()
  async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = user.uid;
      print(currentId);
    });
  }

 Widget buildUser(BuildContext context , DocumentSnapshot snapshot)
 {

   Future<String> getProfile()
   async {

     return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);

   }

   var id = snapshot.documentID;
   var name = snapshot['name'];

   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
//       color: Colors.white,
       child: InkWell(
         onTap: () {
           if(currentId == snapshot.documentID)
             {
               Navigator.pushNamed(context, '/myProfile');
             }
           else
             {
               Navigator.pushNamed(context, '/searchedUser' , arguments: {
                 'id' : id,
                 'name' : name,
               });
             }

         },
         child:
         Row(
           children: <Widget>[
             SizedBox(width: 5,),

             CircleAvatar(

                 backgroundColor: Colors.white,
                 radius: 20,
                 child : FutureBuilder(
                     future: getProfile(),
                     builder:(context ,AsyncSnapshot<String> snapshot) {

                       if(snapshot.hasData)
                       {
                         return ClipOval(
                           child: SizedBox(
                             height: 36,
                             width: 36,
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
                         return Icon(
                           Icons.person,
                         );
                       }
                     }
                 )
             ),
             SizedBox(width: 10,),
             Center(
               child: Text(snapshot['name'],
                   style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 18,
                       //  fontFamily: 'Pacifico',
                       color: Colors.deepPurple
                   )),
             ),
           ],
         ),
       ),
     ),
   );
 }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }
  @override

  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 3.0,
            brightness: Brightness.dark,
            titleSpacing: 2.0,
            title: Text(data["name"],
              style : TextStyle(
          //      fontFamily: 'Pacifico',
                fontSize: 20.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xff09203f),

          ),
          body : Container(
            /*decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffff512f),
                  Color(0xffdd2476)
                ], //Color(0xff009fff) ,Color(0xffec2f4b)],

                // begin : Alignment.topLeft,
                //   end : Alignment.bottomRight
              ),
            ),*/

            child: StreamBuilder(
              stream: Firestore.instance.collection('Ravan').where('name', isLessThanOrEqualTo: data['name']).snapshots(),
              builder: (context , snapshot)
              {

                if(!snapshot.hasData) return Loading();
                else if(snapshot.data.documents.length < 1){
                  return Center(
                          child: Text("No Users Found" ,style: TextStyle(color: Colors.white,fontSize: 22 ),
                          )
                  );
                }

                return ListView.builder(
                    itemBuilder: (context , index) => buildUser(context ,snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                );
              }
            ),
          ),
      ),
    );
  }
}
