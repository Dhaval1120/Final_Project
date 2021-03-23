
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {


  String currentUser , currentId ,currentProfile;

  Future<Widget> setName()
  async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance.collection('Ravan').document(user.uid).get().then((value)  {

      setState(() {
        currentUser = value["name"];
        currentId = user.uid;
        //currentProfile = value["image"],
        print(currentId);
      });
    });
  }

  //var profilePic;
  Widget buildUser(BuildContext context , DocumentSnapshot snapshot ,int index ,int length)
  {
    var id;
    print("Building User");
    id = snapshot.documentID;
    print(id);


    Future<String> getProfile()
    async {

      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);

    }

    return Container(
      /*decoration: BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(width: 1))
      )*/

      height : 50,
      //color: Colors.white,
      child: InkWell(

        onTap: (){
          if(currentId == id)
            {
              Navigator.pushNamed(context, '/myProfile');
            }
          else
          {
            Navigator.pushNamed(context, '/searchedUser' , arguments: {
              'id' : id,
              'name' : snapshot['name'],
            });
          }
            },
        child: Row(
          children: <Widget>[
            SizedBox(width: 5,),

            CircleAvatar(

              backgroundColor: Colors.blue,
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
        )
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setName();
  }

  var data;

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3.0,
          brightness: Brightness.dark,
          titleSpacing: 2.0,
          title: Text("Following",
            style : TextStyle(
              //     fontFamily: 'Pacifico',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff09203f),

        ),

        body: Container(
          decoration: BoxDecoration(
            /*radient: LinearGradient(
              colors: [
                Color(0xffff512f),
                Color(0xffdd2476)
              ], //Color(0xff009fff) ,Color(0xffec2f4b)],

              // begin : Alignment.topLeft,
              //   end : Alignment.bottomRight
            ),*/
          ),
          child: StreamBuilder(
              stream: Firestore.instance.collection('Ravan').document(data['id']).collection('Following').snapshots(),
              builder: (context , snapshot)
              {

                if(!snapshot.hasData) return Loading();
                else if(snapshot.data.documents.length < 1){
                  return Center(
                      child: Text("No Users Found" ,style: TextStyle(color: Colors.black,fontSize: 22 ),
                      )
                  );
                }
                return ListView.builder(
                  itemBuilder: (context , index) => buildUser(context ,snapshot.data.documents[index] ,index ,snapshot.data.documents.length),
                  itemCount: snapshot.data.documents.length,
                );
              }
          ),
        ),
      ),
    );
  }
}
