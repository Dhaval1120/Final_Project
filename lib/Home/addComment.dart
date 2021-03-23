import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AddComment extends StatefulWidget {
  String commnentId= '';

  AddComment({this.commnentId}){
    print(" Comment id is $commnentId");
  }
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

  String userId = '' , comment = '';
  TextEditingController controller = TextEditingController();
  List commentsData = List();
  getComments() async{
    Firestore.instance.collection('Ravan').document(userId).collection("NewsFeed").document(widget.commnentId).collection("Comments").getDocuments()
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
    Firestore.instance.collection('Ravan').document(userId).collection("NewsFeed").document(widget.commnentId).collection("Comments")
        .add({
       'comment' : comment,
       'userId' : userId,
       'timeStamp' : DateTime.now().toUtc()
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
      body: Stack(
        children: [
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Color(0xffffe4b5),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(itemCount : commentsData.length,itemBuilder: (BuildContext context, int index){
                      return Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(commentsData[index]['comment']),
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
                          IconButton(
                            icon: Icon(Icons.photo) ,
                            color: Colors.indigo,
                            iconSize: 40,
                            onPressed: (){
                            },
                          ),
                          Expanded(
                            child: TextField(
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
                              controller.clear();
                            },
                            child: CircleAvatar(
                              // backgroundColor: Color(0xff00ffff),
                              backgroundColor:  Color(0xff6495ed),
                              radius: 30,
                              child: Icon(

                                Icons.send,
                                color: Colors.white,
                                // size: 25,
                              ),
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
