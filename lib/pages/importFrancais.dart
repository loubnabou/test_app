import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'forms.dart';
class table extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Insert(),
    );

  }

}
class CourseApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Les Tests"),
      backgroundColor: Colors.deepPurpleAccent,),
      body:  StreamBuilder(
        stream: Firestore.instance.collection("Test").snapshots() ,
        builder: (context, snapshot){
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              DocumentSnapshot tests =snapshot.data.documents[index];
           return ListTile(

              title: Text(tests['titreDeTest'],
              style: TextStyle(fontSize: 25,),),
              subtitle: Text(tests['sujetDeTest']),
             leading: Icon(Icons.check_circle,
               color: Color(0xFF7a34c5),),
              );
            },
          );
        }
      ),
    );
  }


}

