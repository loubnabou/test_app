import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/import.dart';
import 'package:tesapp/pages/testQuestionsArabe.dart';

import 'importArabe.dart';

class MyArabeTestApp extends StatelessWidget {
  final FirebaseUser user;
  final bool isFirstTime;
  final String testKey;
  MyArabeTestApp({this.user, this.isFirstTime = true, this.testKey = ''});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (BuildContext context) {
              return InsertArabe(
                user: user,
                isFirstTime: isFirstTime,
                testKey: testKey,
              );
            },
          ),
        );
      },
    );
  }
}

class InsertArabe extends StatefulWidget {
  final FirebaseUser user;
  final bool isFirstTime;
  final String testKey;
  InsertArabe({this.user, this.isFirstTime = true, this.testKey = ''});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsertArabeState();
  }
}

class InsertArabeState extends State<InsertArabe> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titreDeTest = TextEditingController();
  TextEditingController sujetDeTest = TextEditingController();
  TextEditingController nbrQuestions = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تحميل الاختبار",
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: Color(0xFF0513AD),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    controller: titreDeTest,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "لا يمكن ان يكون فارغا";
                      } else {
                        return null;
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "ادخل عنوان الاختبار "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    controller: sujetDeTest,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "لا يمكن ان يكون فارغا";
                      } else {
                        return null;
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "ادخل موضوع الاختبار "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text(
                      "الذهاب لاضافة اسئلة الاختبار ",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xFF0513AD),
                    onPressed: () async {
                      /*await(sendData()
                        );
*/
                      if (formKey.currentState.validate()) {
                        /*int counterOfTests = 0;
                        QuerySnapshot querySnapshot = await Firestore.instance
                            .collection("Coachs")
                            .getDocuments();
                        for (int i = 0;
                            i < querySnapshot.documents.length;
                            i++) {
                          var a = querySnapshot.documents[i];
                          if (a.data.values.contains(widget.user.email)) {
                            counterOfTests++;
                          }
                        }*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyArabeQuestionsApp(
                              isFirstTime: widget.isFirstTime,
                              testKey: widget.testKey,
                            ),
                            settings: RouteSettings(
                              arguments: {
                                "titreDeTest": titreDeTest.text,
                                "sujetDeTest": sujetDeTest.text,
                                "user_data": widget.user,
                                //"counterOfDocs": counterOfTests
                              },
                            ),
                          ),
                        );

                        titreDeTest.clear();
                        sujetDeTest.clear();
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("لا يمكن ان تترك الحقول فارغة"),
                        ));
                      }
                    },
                  ),
                ),
                widget.isFirstTime ? Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text(
                      "مشاهدة جميع الاختبارات الخاصة بك  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xFF0513AD),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseArabeApp(user: widget.user),
                        ),
                      );
                    },
                  ),
                ) : Padding(padding: EdgeInsets.all(10.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
