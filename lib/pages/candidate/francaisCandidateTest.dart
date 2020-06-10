import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/invitation_test.dart';

class MakeFrancaisCandidateTest extends StatefulWidget {
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  MakeFrancaisCandidateTest({this.isFirstTime = true, this.invitationKey});
  @override
  _MakeFrancaisCandidateTestState createState() =>
      _MakeFrancaisCandidateTestState();
}

class _MakeFrancaisCandidateTestState extends State<MakeFrancaisCandidateTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: Text("Un Test"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("Coachs").getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                Widget msgWidget;
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  var a = snapshot.data.documents[i];
                  Test test = Test.fromJson(a.data);
                  if (test.testID == widget.invitationKey.testID &&
                      test.language == 'fr') {
                    msgWidget = FrancaisTestCarousel(
                      test: test,
                    );

                    break;
                  } else {
                    msgWidget = Center(
                      child: Text(
                          "Test may be not approved yet, check again after some time"),
                    );
                  }
                }
                return msgWidget;
              }
          }
        },
      ),
    );
  }
}

class FrancaisTestCarousel extends StatefulWidget {
  final Test test;
  FrancaisTestCarousel({this.test});
  @override
  _FrancaisTestCarouselState createState() => _FrancaisTestCarouselState();
}

class _FrancaisTestCarouselState extends State<FrancaisTestCarousel> {
  PageController _testQuestionsPageController;
  int currentpage = 0;
  List<String> list;
  bool isLastQuestion = false;

  @override
  initState() {
    super.initState();
    list = new List<String>();
    _testQuestionsPageController = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 1.0,
    );
  }

  @override
  dispose() {
    _testQuestionsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10.0,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.57,
          child: PageView.builder(
            controller: _testQuestionsPageController,
            scrollDirection: Axis.horizontal,
            reverse: false,
            itemCount: widget.test.questions.length - 1,
            itemBuilder: (context, index) {
              index == widget.test.questions.length - 2
                  ? isLastQuestion = true
                  : isLastQuestion = false;
              Question question = Question.fromJson(
                  widget.test.questions['Question' + (index + 1).toString()]);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            (index + 1).toString() + ". " + question.question,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          )),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.test.answers.length,
                        itemBuilder: (ctx, indexVal) {
                          return Card(
                            elevation: 20.0,
                            child: ListTile(
                              title: Text(
                                (indexVal + 1).toString() +
                                    ". " +
                                    widget.test.answers[indexVal],
                                style: TextStyle(fontSize: 17.0),
                              ),
                              onTap: (){
                                print(indexVal);
                              },
                            ),
                          );
                        }),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: RaisedButton(
                          elevation: 10.0,
                          color: isLastQuestion
                              ? Colors.red[700]
                              : Colors.blue[500],
                          child: Text(
                            isLastQuestion
                                ? "Finish".toUpperCase()
                                : "Continue".toUpperCase(),
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {}),
                    ))
                  ],
                ),
              );
            },
            onPageChanged: (pageNum) {
              setState(() {
                currentpage = pageNum;
              });
            },
          ),
        ),
      ),
    );
  }
}

class TestQuestionAnswer {
  bool isSelected = false;
  String questionAnswer;

  TestQuestionAnswer(this.questionAnswer);
}
