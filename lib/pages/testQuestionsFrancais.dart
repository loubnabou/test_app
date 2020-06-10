import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsArabe.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/importFrancais.dart';
import 'package:tesapp/pages/invitation_test.dart';

class CustomTextField extends StatefulWidget {
  bool isFirstTime;
  String testKey;
  CustomTextField({this.isFirstTime = true, this.testKey = ''});
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
    /*int counterOfDocs = rcvdData['counterOfDocs'];
    counterOfDocs +=1;*/

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
            var answers = [
              'Pas du tout',
              'Peut etre',
              'Quelques fois',
              'Souvent',
              'Tout a fait'
            ];
            String language = 'fr';
            String username = user.email;

            Map<String, Object> questions = new Map<String, Object>();
            String testKey = '';
            if (widget.isFirstTime) {
              testKey = Utils.createCryptoRandomString();
            } else {
              testKey = widget.testKey;
            }
            questions['testID'] = testKey;

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
                testID: testKey,
                questions: questions,
                answers: answers);

            var _data = test.toJson();
            dataFirebase.sendData("Coachs", _data);
            //print(_data);

            // clear text fields after add exam
            _controller.clear();
            for (int i = 0; i < number; i++) {
              _questionsController[i].clear();
            }

            if (widget.isFirstTime) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyArabeTestApp(
                    user: user,
                    isFirstTime: false,
                    testKey: testKey,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseApp(
                    user: user,
                  ),
                ),
              );
            }
          },
          child: new Icon(Icons.check),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
    );
  }
}
