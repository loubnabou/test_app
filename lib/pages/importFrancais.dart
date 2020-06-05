import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/testDetails.dart';

import 'forms.dart';

class Table extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Insert(),
    );
  }
}

class CourseApp extends StatelessWidget {
  final FirebaseUser user;
  CourseApp({this.user});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Les Tests"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("Coachs").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Widget widget;
                  DocumentSnapshot tests = snapshot.data.documents[index];

                  tests.data.forEach((key, value) {
                    Test test = Test.fromJson(tests.data);
                    if (test.coachName == user.email && test.language == 'fr') {
                      widget = ListTile(
                        title: Text(
                          test.title,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        subtitle: Text(test.subject),
                        leading: Icon(
                          Icons.check_circle,
                          color: Color(0xFF7a34c5),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestDetails(
                                test: test,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  });

                  return widget;
                },
              );
            }
          }),
    );
  }
}
