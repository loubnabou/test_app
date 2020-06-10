import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/import.dart';
import 'package:tesapp/pages/testQuestionsFrancais.dart';

import 'importFrancais.dart';

class DataFirebase {
  void sendData(String collectionType, dynamic data) async {
    await Firestore.instance.collection(collectionType).add(data);
  }
}

class InsertFrancais extends StatefulWidget {
  final bool isFirstTime;
  final FirebaseUser user;
  final String testKey;
  InsertFrancais({this.user, this.isFirstTime = true, this.testKey = ''});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsertFrancaisState();
  }
}

class InsertFrancaisState extends State<InsertFrancais> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titreDeTest = TextEditingController();
  TextEditingController sujetDeTest = TextEditingController();
  TextEditingController nbrQuestions = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Importer Test"),
        backgroundColor: Colors.deepPurpleAccent,
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
                        return "it is empty";
                      } else {
                        return null;
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "entrer le titre de test "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    controller: sujetDeTest,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "it is empty";
                      } else {
                        return null;
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "entrer le sujet de test "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text(
                      "commencer l'insertion des questions ",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.deepPurpleAccent,
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
                            builder: (context) => CustomTextField(
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
                          content: Text("you cannot make the field empty"),
                        ));
                      }
                    },
                  ),
                ),
                widget.isFirstTime ? Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text(
                      "table des Tests  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.deepPurpleAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseApp(user: widget.user),
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

class Test {
  final String language;
  final String title;
  final String subject;
  final int numOfQuestions;
  final String testID;
  final Map<String, Object> questions;
  final String coachName;
  final int numOfTestAnswers;
  var answers;

  Test(
      {this.title,
      this.subject,
      this.numOfQuestions,
      this.numOfTestAnswers = 5,
      this.testID,
      this.questions,
      this.coachName,
      this.answers,
      this.language});

  factory Test.fromJson(Map<dynamic, dynamic> json) {
    return Test(
      language: json['language'],
      coachName: json['coachName'],
      title: (json['Test'])['title'],
      subject: (json['Test'])['subject'],
      testID: (json['Test'])['testID'],
      numOfQuestions: (json['Test'])['numOfQuestions'],
      numOfTestAnswers: (json['Test'])['numOfTestAnswers'],
      answers: (json['Test'])['Answers'],
      questions: (json['Test'])['Questions'],
    );
  }

  Map<String, Object> toJson() {
    return {
      "language": language != null ? language : 'unknown',
      "coachName": coachName != null ? coachName : 'unknown',
      "Test": {
        "testID": testID != null ? testID : 'unknwon',
        "title": title != null ? title : 'unknwon',
        "subject": subject != null ? subject : 'unknwon',
        "numOfQuestions": numOfQuestions != null ? numOfQuestions : 0,
        "numOfTestAnswers": numOfTestAnswers != null ? numOfTestAnswers : 5,
        "Questions": questions,
        "Answers": answers
      }
    };
  }

  dynamic testToJson(Test data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }
}

class Question {
  final String question;
  final int numOfQuestionAnswers;
  final String questionID;

  Question({this.question, this.numOfQuestionAnswers = 1, this.questionID});

  factory Question.fromJson(Map<dynamic, dynamic> json) {
    return Question(
      question: json['question'],
      numOfQuestionAnswers: json['numOfQuestionAnswers'],
      questionID: json['questionID'],
    );
  }

  Map<String, Object> toJson() {
    return {
      "question": question != null ? question : 'unknown',
      "questionID": questionID != null ? questionID : 'unknown',
      "numOfQuestionAnswers":
          numOfQuestionAnswers != null ? numOfQuestionAnswers : 1
    };
  }
}
