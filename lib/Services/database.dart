
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:obvio/Home/userproperties.dart';

class DatabaseService {

  final String uid;
  String event_name = '';
  String location = '';
  String date = '';
  String time = '';

  DatabaseService({this.uid});

  final CollectionReference ravan = Firestore.instance.collection('Ravan');
  final CollectionReference events = Firestore.instance.collection('EventDetails');


  Future updateUserData(String name, String username, String email,
      String password , String id, String image) async {
    return await ravan.document(uid).setData(
        {'name': name,
          'username': username,
          'email': email,
          'docId' : uid,
          'id' : id,
          'image' : image,
          'password': password,
          'followers' : 0,
          'friends' : 0,
        }
    );
  }

  Future addEventToUserFirebase(String event_name, String host_name,
      String location, String startdate,String enddate , String about,String time , int id ,String currentId ,String currentName,
      String department , String level
      )
  async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user.uid);
    return await Firestore.instance.collection('Ravan').document(user.uid).collection('Events').add({
         'event_name': event_name,
         'host_name': host_name,
         'location': location,
         'startdate': startdate,
         'enddate' : enddate,
         'about' : about,
         'currentId' : currentId,
         'currentName' : currentName,
         'time': time,
         'Id' : id,
         'department' : department,
         'level' : level,
         'isPending' : true,
         'timeStamp' : DateTime.now().toUtc().toString()
       }).then((value) {
         events.document(value.documentID).setData({
           'event_name': event_name,
           'host_name': host_name,
           'location': location,
           'startdate': startdate,
           'enddate' : enddate,
           'about' : about,
           'time': time,
           'id' : id,
           'department' : department,
           'level' : level,
           'currentName' : currentName,
           'currentId' : currentId,
           'isPending' : true,
           'timeStamp' : DateTime.now().toUtc().toString()
         });
    });
  }
  Future addEventToFirebase(String event_name, String host_name,
      String location, String startdate,String enddate,String about, String time , int id , String currentId ,String currentName) async {
    return await events.add({
      'event_name': event_name,
      'host_name': host_name,
      'location': location,
      'startdate': startdate,
      'enddate' : enddate,
      'about' : about,
      'time': time,
      'id' : id,
      'currentName' : currentName,
      'currentId' : currentId,
      'timeStamp' : DateTime.now().toUtc().toString()
    });
  }

  Future deleteEvent(int docId)
  {
    print(docId);
   return events.document(docId.toString()).delete().then((value) => print("deleted"));
  }
  List<EventDetails> eventDetailsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return EventDetails(
        event_name: doc.data['event_name'],
        location: doc.data['location'],
        date: doc.data['date'],
        time: doc.data['time'],
      );
      /*return EventDetails(
                title : doc.data['title'],
                subtitle : doc.data['subtitle'],
                number: doc.data['number']
              );*/
    }).toList();
  }

  Stream<List<EventDetails>> get notifications {
    return events.snapshots()
        .map(eventDetailsFromSnapshot);
  }
}
