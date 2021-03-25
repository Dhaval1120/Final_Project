import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:obvio/Home/imagepicker.dart';

class AddComment extends StatefulWidget {
  String commentId= '' , imageId = '' , imageUserId = '';

  AddComment({this.commentId , this.imageId ,this.imageUserId}){
    print(" Comment id is $commentId $imageUserId");
  }
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

 // Map userInfo = Map<String , String>();
  List<Map> userInfo = List();
  String userId = '' , comment = '';
  TextEditingController controller = TextEditingController();
  List commentsData = List();
  getComments() async{
    Firestore.instance.collection('Ravan').document(widget.imageUserId).collection("MyImages").document(widget.commentId).collection("Comments").orderBy("timeStamp" , descending: true).getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            setState(() {
              commentsData.add(element);
            });
          });
          print(" len is ${value.documents.length}");
    });
  }

  addCommentToFirestore() async{
    Firestore.instance.collection('Ravan').document(widget.imageUserId).collection("MyImages").document(widget.commentId).collection("Comments").add({
       'comment' : comment,
       'type' : "text",
       'userId' : userId,
       'timeStamp' : DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      if(commentsData.isNotEmpty)
        {
          setState(() {
            commentsData.clear();
            getComments();
          });
        }
    });
  }

  Future getCommentUserInfo(var comment) async{
    print("commentData ${comment['userId']}");
    DocumentReference documentReference = Firestore.instance.collection("Ravan").document(comment['userId']);
    return documentReference.get().then((value) {
      // setState(() {
      //   userInfo.add(value.data);
      // });
       return value.data['name'];
    });
  }
  Future getCommentUserInfoProfile(var comment) async{
    print("commentData ${comment['userId']}");
    DocumentReference documentReference = Firestore.instance.collection("Ravan").document(comment['userId']);
    return documentReference.get().then((value) {
      // setState(() {
      //   userInfo.add(value.data);
      // });
      return value.data['image'];
    });
  }
  getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    getComments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.indigo,
      //   title: Text("Comments"),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Container(
            child: Column(
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
                      height: 50,
                      child: Center(child: Text("Comment" ,style: TextStyle(color: Colors.white,
                        fontSize: 17
                      ), ),),
                      //color: Colors.redAccent
                    ),
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10) , bottomRight: Radius.circular(10))
                ),
                Expanded(
                  child: Container(
                   // color: Color(0xffffe4b5),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(itemCount : commentsData.length,itemBuilder: (BuildContext context, int index){
                      return Container(
                        //color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                          child: ListTile(
                            leading: FutureBuilder(future : getCommentUserInfoProfile(commentsData[index]),builder: (BuildContext context , AsyncSnapshot snapshot){
                              if(snapshot.hasData)
                                {
                                  return CircleAvatar(
                                    radius: 20,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data,
                                      ),
                                    ),
                                  );
                                }
                              else
                                {
                                  return CircleAvatar(
                                    backgroundColor:  Colors.indigo,
                                  );
                                }
                            },),
                           // tileColor: Colors.pinkAccent,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  builder: (BuildContext context , AsyncSnapshot snapshot){
                                  if(snapshot.hasData)
                                    {
                                      return Text(snapshot.data);
                                    }
                                  else
                                    {
                                      return Text(" Mike ");
                                    }
                                },
                                future: getCommentUserInfo(commentsData[index])
                                ),
                                Text(commentsData[index]['comment']),
                              ],
                            ),
                          )
                        ),
                      );
                    }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: controller,
                              onChanged: (value){
                                setState(() {
                                  comment = value;
                                });
                              },
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.purple,
                                hoverColor: Colors.red,
                                hintText: "Add Comment",
                                fillColor: Colors.white,
                                border : OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.blueGrey,width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 2)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4,),
                          InkWell(
                            onTap: (){
                              addCommentToFirestore();
                              setState(() {
                                controller.clear();
                              });
                            },
                            child: CircleAvatar(
                              // backgroundColor: Color(0xff00ffff),
                              backgroundColor:  Colors.deepOrangeAccent,
                              radius: 25,
                              child: Image(
                                height: 40,
                                width: 40,
                                image: AssetImage("assets/send_icon.png"),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
