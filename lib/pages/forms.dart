import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesapp/pages/import.dart';

import 'importFrancais.dart';

void main() {
  runApp(MyApp());
}

class DataFirebase{


  void sendData(String collectionType, dynamic data) async{
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

class Insert extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsertState();
  }

}
class InsertState extends State<Insert>{
  final formKey= GlobalKey<FormState>();

  TextEditingController titreDeTest = TextEditingController();
  TextEditingController sujetDeTest = TextEditingController();
  TextEditingController nbrQuestions = TextEditingController();



  InsertState();

  /**/
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Importer Test"),
        backgroundColor: Colors.deepPurpleAccent,),
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child:Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    controller: titreDeTest,
                    validator: (value){
                      if(value.isEmpty){
                        return"it is empty";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "entrer le titre de test "
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    controller: sujetDeTest,
                    validator: (value){
                      if(value.isEmpty){
                        return"it is empty";
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "entrer le sujet de test "
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text("commencer l'insertion des questions ", style: TextStyle(color: Colors.white),),
                    color: Colors.deepPurpleAccent,



                    onPressed: () async{
                      /*await(sendData()
                        );
*/
                      if(formKey.currentState.validate()){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>CustomTextField(),
                          settings: RouteSettings(
                            arguments: {
                              "titreDeTest" : titreDeTest.text,
                              "sujetDeTest" : sujetDeTest.text
                            },
                          ),
                        ),

                        );


                        titreDeTest.clear();
                        sujetDeTest.clear();
                      }

                      else{
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("you cannot make the field empty"),));
                      }


                    },




                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    child: Text("table des Tests  ", style: TextStyle(color: Colors.white),),
                    color: Colors.deepPurpleAccent,
                    onPressed: (){
                      /*Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CourseApp(),
                            ),
                            );*/
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

  final formKey= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final  Map<String, Object>rcvdData = ModalRoute.of(context).settings.arguments;

    return Scaffold(

      appBar: AppBar(
        backgroundColor:  Colors.deepPurpleAccent,
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
            return  Padding(
              padding: EdgeInsets.all(25.0),
              child:TextField(
                controller: _questionsController[index],
                cursorColor: Colors.pinkAccent,
                decoration: InputDecoration(icon: Icon(Icons.mode_edit,
                  color: Color(0xFF7a34c5),
                ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),//bach ndiro dak chkl dyal textfield
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
        opacity : _showSaveBtn ? 1.0 : 0.0,
        child : new FloatingActionButton(
          onPressed: () {
            var answers = [];

            var questions = new Map();
            questions['testID'] = "Loubna" + 1.toString();

            for(int i=0; i<number; i++){
              Question question = new Question(
                  question : _questionsController[i].text,
                  questionId : rcvdData['sujetDeTest'].toString() + (i+1).toString(),
                  answers : answers
              );
              questions["Question"+(i+1).toString()] = question.toJson();
            }


            Test test = new Test(
                coachName: "Loubna",
                title: rcvdData['titreDeTest'].toString(),
                subject: rcvdData['sujetDeTest'].toString(),
                numOfQuestions: number,
                testId: "Loubna" + 1.toString(),
                questions: questions
            );

            //var _data = test.toJson();
            //dataFirebase.sendData("Coachs", _data);


            //print(test.testToJson(test));

            var data = {
              "coachName" : "Samir",
              "Test" : {
                "testID" : "Samir1",
                "title" : "Math",
                "subject" : "Integration",
                "numOfQuestions" : 1,
                "Questions" : {
                  "testID" : "Samir1",
                  "Question1" : {
                    "questionID" : "Integration1",
                    "question" : "What is sin(45) ?",
                    "numOfAnswers" : 2,
                    "Answers" : []
                  }
                }
              }
            };

            //print(data);

            dataFirebase.sendData("Coachs", data);


            // clear text fields after add exam
            _controller.clear();
            for(int i=0; i<number; i++){
              _questionsController[i].clear();
            }

          },
          child: new Icon(Icons.check),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
    );
  }
}


class Question{
  final String question;
  final int numOfAnswers;
  final String questionId;
  var answers;


  Question({this.question,
    this.numOfAnswers = 0,
    this.questionId,
    this.answers});

  /*
  factory Question.fromJson(Map<dynamic, dynamic> json){
    return Question(
     question: json['question'],
     questionId: json['questionID'],
     numOfAnswers: json['numOfAnswers'] as int,
     // code here may be changed
     answers : json['Answers'],
    );
  }
  */

  Map<dynamic, dynamic> toJson(){
    return {
      "question": question,
      "questionID": questionId,
      "numOfAnswers" : numOfAnswers,
      "Answers" : answers
    };
  }

}

class Test{

  final String title;
  final String subject;
  final int numOfQuestions;
  final String testId;
  final Map<dynamic, dynamic> questions;
  final String coachName;

  Test({this.title,
    this.subject,
    this.numOfQuestions,
    this.testId,
    this.questions,
    this.coachName});

  /*
  factory Test.fromJson(Map<dynamic, dynamic> json){
    return Test(
     title: json['title'],
     subject: json['subject'],
     numOfQuestions: json['numOfQuestions'] as int,
     testId: json['testID'],
     questions : json['Questions'],
     coachName : json['coachName']
    );
  }
  */

  Map<dynamic, dynamic> toJson(){
    return {
      "coachName" : coachName,
      "Test": {
        "title": title,
        "subject": subject,
        "numOfQuestions": numOfQuestions,
        "testID" : testId,
        "Questions" : questions
      }
    };
  }

  /*
  List<Test> testFormJson(dynamic strJson){
    final str = json.decode(strJson);
    return List<Test>.from(str.map((item){
      return Test.fromJson(item);
    }));
  }
  */

  dynamic testToJson(Test data){
    final dyn = data.toJson();
    return json.encode(dyn);
  }

}



class Answer{
  final String answer;

  Answer({this.answer});

/*
  factory Answer.fromJson(Map<dynamic, dynamic> json){
    return Answer(answer: json['answer']);
  }
  */
/*
  List<dynamic> toJson(){
    return [answer];
  }
  */
}


/*var data = {
            "coachName" : "Loubna",
            "Test" : {
              "testID" : "Loubna1",
              "title" : "Math",
              "subject" : "Integration",
              "numOfQuestions" : 2,
              "Questions" : {
                "testID" : "Loubna1",
                "Question1" : {
                  "questionID" : "Integration1",
                  "question" : "What is tan(45) ?",
                  "numOfAnswers" : 2,
                  "Answers" : [
                    "1",
                    "0"
                  ]
                }
              }
            }
          };*/