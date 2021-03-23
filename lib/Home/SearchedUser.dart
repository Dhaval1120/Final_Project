import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obvio/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchedUser extends StatefulWidget {
  @override
  _SearchedUserState createState() => _SearchedUserState();
}

class _SearchedUserState extends State<SearchedUser> {

  var currentName;
  var currentId , following ="" , followers = "";

  Future<void> sendFriend(String docId , String name1) async {
   print("SendFriend");

   print(docId);
   print('senreq');
   print(currentId);

    Firestore.instance.collection('Ravan').document(currentId).get().then((value) => {
        currentName = value['name'],
        print(currentName),
    });

    Firestore.instance.collection("Ravan").document(docId).collection('Requests').add({
      'name' :  currentName,
      'docId' : currentId,

    });

   Firestore.instance.collection("Ravan").document(currentId).collection('Requested').document(docId).setData({
     'docId': docId,
   });
   }

  var str1 = " ";

  bool requested;
//  var followers = "", following = "";
  var str2 = 'Requested';


  void setUserData()
  async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentId = user.uid;
      print(currentId);


    });

    Firestore.instance.collection('Ravan').document(currentId).get().then((value)
    {
      setState(() {
        currentName = value['name'];
      });
    });
  }

 bool isfollowing;

 Future<void> checkFollowing(String id)
 async{

   Firestore.instance.collection('Ravan').document(id).collection("Followers").getDocuments().then((value)
   {
     setState(() {
       followers = value.documents.length.toString();
     });
   });

   Firestore.instance.collection('Ravan').document(id).collection('Following').getDocuments().then((value){
     setState(() {
       following = value.documents.length.toString();
     });
   });

   Firestore.instance.collection('Ravan').document(currentId).collection('Following').document(id).get().then((value) {
     if(!value.exists)
       {
         setState(() {


           isfollowing = false;

         });
         //str1 = "Be My Friend";
         //checkRequested(id);
         Firestore.instance.collection('Ravan').document(currentId).collection('Requested').document(id).get().then((value){

           if(!value.exists)

             {
               setState(() {
                 requested = false;
                 str1 = "Be My Friend";
               });
             }
           else{
             setState(() {
               requested = true;
               str1 = str2;
             });
           }

         });
         

       }
     else
       {
         setState(() {
           str1 = "Following";
           isfollowing = true;
         });
       }
   });
 }
  @override
  void initState()
  {
    super.initState();
    setUserData();
    //checkRequested(currentId);
     }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Map data = ModalRoute.of(context).settings.arguments;

    checkFollowing(data['id']);

    return Scaffold(

      appBar: AppBar(
        elevation: 3.0,
        brightness: Brightness.dark,
        titleSpacing: 2.0,
        title: Text(data['name'],
          style : TextStyle(
           // fontFamily: 'Pacifico',
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff09203f),

      ),

      body : StreamBuilder(


          stream: Firestore.instance.collection('Ravan').document(data['id']).snapshots(),
          builder: (context,snapshot){


            print(data['id']);
            if(!snapshot.hasData){
              return Loading();
            }
            
            //checkRequested(data['id']);
            //name = snapshot.data["name"];
            //profilepic = snapshot.data["image"];
            return SafeArea(
              child: Scaffold(
                // backgroundColor: Colors.lightBlue,
                body : Container(
                  /*decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      //end: Alignment.bottomRight,
                      colors: [Color(0xffB7F8DB),Color(0xff50A7C2)], //[Color(0xff29323c),Color(0xff485563)],


                    ),
                    ),*/
                  child: Stack(

                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          /*Padding(
                            padding: const EdgeInsets.all(8.0),
                              child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(

                                radius: 30,
                                backgroundColor: Colors.white,
                                child: InkWell(
                                  onTap: () => sendFriend(snapshot.data["docId"] , snapshot.data['name']),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 35,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                //color: Colors.redAccent
                                  border: Border.all(
                                      color: Colors.indigo,
                                      width: 3

                                  ),

                                  gradient: LinearGradient(
                                      colors: [Color(0xffff512f),Color(0xffdd2476)]
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  CircleAvatar(

                                    backgroundColor: Colors.white,
                                    radius: 100,
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Image(

                                            image: CachedNetworkImageProvider(
                                                snapshot.data["image"]),
                                            //NetworkImage(snapshot.data["image"]),//snapshot.data.documents[0]['image']),
                                            fit: BoxFit.contain

                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Text(snapshot.data['name']
                                          ,style : TextStyle(
                                              fontSize: 23,
                                              fontFamily: "Pacifico",
                                              color: Colors.white
                                          ),),
                                      ),


                                    ],
                                  ),

                                  SizedBox(height:12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              color: Colors.blueAccent,
                                              child: Text("Followers",style: TextStyle(
                                                  fontSize: 20,
                                                  // fontFamily: 'Pacifico',
                                                  color: Colors.white

                                              ),),
                                              onPressed: () => {
                                                Navigator.pushReplacementNamed(context, '/followers' , arguments: {
                                                  'id' : data['id'],
                                                })
                                              },
                                            ),
                                          ),
                                          Text(followers,style: TextStyle(
                                              fontSize: 20,
                                              // fontFamily: 'Pacifico',
                                              color: Colors.white
                                          ),),
                                          SizedBox(height: 3,)
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              color: Colors.blueAccent,
                                              child: Text("Following",style: TextStyle(
                                                  fontSize: 20,
                                                  // fontFamily: 'Pacifico',
                                                  color: Colors.white

                                              ),),
                                              onPressed: () =>
                                              {
                                                Navigator.pushNamed(context, '/following' , arguments: {
                                                  'id' : data['id'],
                                                })
                                              },

                                            ),
                                          ),
                                          Text(following , style: TextStyle(
                                              fontSize: 20,
                                              // fontFamily: 'Pacifico',
                                              color: Colors.white
                                          ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                      ),

                                      elevation: 5,
                                      highlightColor: Colors.redAccent,
                                      highlightElevation: 5,
                                      color: Colors.deepPurpleAccent,

                                      onPressed: (){
                                        Navigator.pushNamed(context, '/chatbox' , arguments: {
                                          'currentId' : currentId,
                                          'friendId' : data['id'],
                                        });
                                      },

                                      child : Text("Message" ,
                                        style: TextStyle(fontSize: 18 , color: Colors.white),
                                      ),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text(str1 , style: TextStyle(fontSize: 18 , color: Colors.white),),

                                      onPressed: () {
                                        
                                        if(str1 == "Following")
                                          {
                                            showDialog(context: context,
                                            barrierDismissible: true,
                                            builder: (context){
                                              return AlertDialog(
                                                content: InkWell(
                                                  onTap: (){
                                                    setState(() {

                                                      print(currentId);
                                                      print("Searched ID");
                                                      print(data['id']);
                                                      isfollowing = false;
                                                      str1 = "Be My Friend";

                                                      Firestore.instance.collection('Ravan').document(currentId).collection('Following').
                                                      document(data["id"]).delete().then((value){
                                                        print(data["id"]);
                                                        print("deleted");
                                                      });

                                                      Firestore.instance.collection('Ravan').document(data['id']).collection('Followers').
                                                      document(currentId).delete().then((value) {
                                                        Navigator.pop(context);
                                                      });
                                                    });

                                                  },

                                                  child: Text(
                                                    "Unfollow" ,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),

                                              );
                                            }
                                            );
                                          }
                                        else if(str1 == "Be My Friend")
                                          {
                                            setState(() {
                                              str1 = str2;
                                            });
                                            Firestore.instance.collection('Ravan').document(data['id']).collection('Requests').
                                            document(currentId).setData({
                                              'docId' : currentId,
                                              'name' : currentName,
                                            });
                                            Firestore.instance.collection('Ravan').document(currentId).collection('Requested').
                                            document(data['id']).setData({
                                              'id' : data['id'],
                                            });

                                          }
                                        else if(str1 == "Requested")
                                          {
                                            setState(() {
                                              str1 = "Be My Friend";
                                            });
                                            Firestore.instance.collection('Ravan').document(data['id']).collection('Requests').
                                            document(currentId).delete();
                                            Firestore.instance.collection('Ravan').document(currentId).collection('Requested').
                                            document(data['id']).delete();
                                          }
                                        },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      elevation: 5,
                                      highlightColor: Colors.redAccent,
                                      highlightElevation: 5,
                                      color: Colors.deepPurpleAccent,
                                      ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),

                          Divider(
                            height: 5,
                            thickness: 2,
                            color: Colors.deepPurple,
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
