
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Home/SearchedUser.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {

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


  Widget buildUser(BuildContext context , DocumentSnapshot snapshot ,int index ,int length)
  {
    print(" Snapshot docID is ${snapshot.documentID}");
    Future<String> getProfile()
    async {
      return await Firestore.instance.collection('Ravan').document(snapshot.data['docId']).get().then((value) => value.data['image']);
    }
    var id = snapshot.documentID;

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        /*decoration: BoxDecoration(
            border: Border.symmetric(vertical: BorderSide(width: 1))

        ),*/

       height : 50 ,
       // color: Colors.white,
        child: InkWell(
          hoverColor: Colors.blueGrey,

          highlightColor: Colors.blueGrey,
          onTap: () {

            if(currentId == id)
            {
              Navigator.pushNamed(context, '/myProfile');
            }
            else
            {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return SearchedUser(searchedId: snapshot.documentID ,name:snapshot['name'] ,);
              }));
            }

          },

             /* Navigator.pushNamed(context, '/searchedUser' , arguments: {
            'id' : id,
            'name' : snapshot['name'],
          }
          ),*/
          child: Row(
            children: <Widget>[

              SizedBox(width: 5,),

              CircleAvatar(

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
                                fit: BoxFit.cover

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
              SizedBox(width: 7,),
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
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setName();
  }

  var data ;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
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
                          leading: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          title: Text(" Followers ", style:  TextStyle(
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
                child: Container(
                  child: StreamBuilder(
                      stream: Firestore.instance.collection('Ravan').document(data['id']).collection('Followers').snapshots(),
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
            ],
          ),
        ),
      ),
    );
  }
}
