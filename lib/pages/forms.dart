import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/import.dart';

import 'importFrancais.dart';

void main() {
  runApp(MyApp());
}

class DataFirebase {
  void sendData(String collectionType, dynamic data) async {
    await Firestore.instance.collection(collectionType).add(data);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Insert(),
    );
  }
}

class Insert extends StatefulWidget {
  final FirebaseUser user;
  Insert({this.user});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsertState();
  }
}

class InsertState extends State<Insert> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titreDeTest = TextEditingController();
  TextEditingController sujetDeTest = TextEditingController();
  TextEditingController nbrQuestions = TextEditingController();

  InsertState();

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Coachs").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
    }
  }

  /**/
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
                        int counterOfTests = 0;
                        QuerySnapshot querySnapshot = await Firestore.instance
                            .collection("Coachs")
                            .getDocuments();
                        for (int i = 0;
                            i < querySnapshot.documents.length;
                            i++) {
                          var a = querySnapshot.documents[i];
                          if(a.data.values.contains(widget.user.email)){
                            counterOfTests++;
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomTextField(),
                            settings: RouteSettings(
                              arguments: {
                                "titreDeTest": titreDeTest.text,
                                "sujetDeTest": sujetDeTest.text,
                                "user_data": widget.user,
                                "counterOfDocs" : counterOfTests
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
                Padding(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  int number = 0;

  TextEditingController _controller = TextEditingController();
  List<TextEditingController> _questionsController = new List();
  DataFirebase dataFirebase = new DataFirebase();
  bool _showSaveBtn = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    FirebaseUser user = rcvdData["user_data"];
    int counterOfDocs = rcvdData['counterOfDocs'];
    counterOfDocs +=1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('entrer le nombre de questions '),
        bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: TextField(
                cursorColor: Colors.pinkAccent,
                decoration: InputDecoration(icon: Icon(Icons.border_color)),
                controller: _controller,
                onSubmitted: (value) {
                  setState(() {
                    number = int.parse(value);
                    _showSaveBtn = true;
                  });
                },
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 100.0)),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            _questionsController.add(new TextEditingController());
            return Padding(
              padding: EdgeInsets.all(25.0),
              child: TextField(
                controller: _questionsController[index],
                cursorColor: Colors.pinkAccent,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.mode_edit,
                    color: Color(0xFF7a34c5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), //bach ndiro dak chkl dyal textfield
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            );
          },
          itemCount: number,
        ),
      ),
      floatingActionButton: Opacity(
        opacity: _showSaveBtn ? 1.0 : 0.0,
        child: new FloatingActionButton(
          onPressed: () {
            var answers = ['a', 'b', 'c', 'd', 'e'];
            String language = 'fr';
            String username = user.email;

            Map<String, Object> questions = new Map<String, Object>();
            questions['testID'] = username + counterOfDocs.toString();

            for (int i = 0; i < number; i++) {
              Question question = new Question(
                  question: _questionsController[i].text,
                  questionID:
                      rcvdData['sujetDeTest'].toString() + (i + 1).toString());
              questions["Question" + (i + 1).toString()] = question.toJson();
            }

            Test test = new Test(
                language: language,
                coachName: username,
                title: rcvdData['titreDeTest'].toString(),
                subject: rcvdData['sujetDeTest'].toString(),
                numOfQuestions: number,
                testID: username + counterOfDocs.toString(),
                questions: questions,
                answers: answers);

            var _data = test.toJson();
            dataFirebase.sendData("Coachs", _data);
            print(_data);

            // clear text fields after add exam
            _controller.clear();
            for (int i = 0; i < number; i++) {
              _questionsController[i].clear();
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseApp(
                  user: user,
                ),
              ),
            );
          },
          child: new Icon(Icons.check),
          backgroundColor: Colors.pinkAccent,
        ),
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

  Map<String, Object> toJson() {
    return {
      "question": question != null ? question : 'unknown',
      "questionID": questionID != null ? questionID : 'unknown',
      "numOfQuestionAnswers":
          numOfQuestionAnswers != null ? numOfQuestionAnswers : 1
    };
  }
}
