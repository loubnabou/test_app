import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/home.dart';
import 'package:tesapp/pages/testDetails.dart';

import 'formsArabe.dart';

class AllArabeTestApp extends StatelessWidget {
  final FirebaseUser user;
  AllArabeTestApp({this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (BuildContext context) {
              return CourseArabeApp(user: user);
            },
          ),
        );
      },
    );
  }
}

class CourseArabeApp extends StatelessWidget {
  final FirebaseUser user;
  CourseArabeApp({this.user});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("الاختبارات"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(result: user),
                  ),
                );
              })
        ],
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
                    if (test.coachName == user.email && test.language == 'ar') {
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
                        onTap: () {},
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
