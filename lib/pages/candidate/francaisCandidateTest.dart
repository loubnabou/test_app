import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/candidate/arabeCandidateTest.dart';
import 'package:tesapp/pages/candidate/calculateResult.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/candidate/testResult.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/invitation_test.dart';

class MakeFrancaisCandidateTest extends StatefulWidget {
  final String email;
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  final List<String> listOfChoisesArabeAnswers;
  final Map<String, Map<String, int>> answersDetailsAR;
  final Test francaisTest;
  final Test arabeTest;
  MakeFrancaisCandidateTest(
      {this.email,
      this.isFirstTime = true,
      this.invitationKey,
      this.listOfChoisesArabeAnswers,
      this.answersDetailsAR,
      this.francaisTest,
      this.arabeTest});
  @override
  _MakeFrancaisCandidateTestState createState() =>
      _MakeFrancaisCandidateTestState();
}

class _MakeFrancaisCandidateTestState extends State<MakeFrancaisCandidateTest> {
  Test arabeTest = new Test();
  Test francaisTest = new Test();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white60,
        appBar: AppBar(
          backgroundColor: Color(0xFF0513AD),
          title: Text("Un Test"),
          automaticallyImplyLeading: widget.isFirstTime ? true : false,
          centerTitle: true,
        ),
        body: widget.isFirstTime
            ? FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection("Coachs").getDocuments(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else {
                        Widget msgWidget;
                        num counterTests = 0;

                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          if (counterTests == 2) break;

                          var a = snapshot.data.documents[i];
                          Test tempTest = Test.fromJson(a.data);
                          if (tempTest.testID == widget.invitationKey.testID) {
                            if (tempTest.language == 'fr') {
                              counterTests++;
                              francaisTest = tempTest;
                            } else {
                              counterTests++;
                              arabeTest = tempTest;
                            }

                            msgWidget = FrancaisTestCarousel(
                              francaisTest: francaisTest,
                              isFirstTime: widget.isFirstTime,
                              invitationKey: widget.invitationKey,
                              arabeTest: arabeTest,
                              email: widget.email,
                              scaffoldKey: _scaffoldKey,
                            );
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
              )
            : FrancaisTestCarousel(
                francaisTest: widget.francaisTest,
                arabeTest: widget.arabeTest,
                isFirstTime: widget.isFirstTime,
                invitationKey: widget.invitationKey,
                listOfChoisesArabeAnswers: widget.listOfChoisesArabeAnswers,
                answersDetailsAR: widget.answersDetailsAR,
                email: widget.email,
                scaffoldKey: _scaffoldKey,
              ),
      ),
    );
  }
}

class FrancaisTestCarousel extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String email;
  final Test arabeTest;
  final Test francaisTest;
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  // if isNotFirstTime, then we need arabeChoicesAnswers to prevent re-request firebase
  final List<String> listOfChoisesArabeAnswers;
  final Map<String, Map<String, int>> answersDetailsAR;
  FrancaisTestCarousel(
      {this.scaffoldKey,
      this.email,
      this.francaisTest,
      this.isFirstTime,
      this.invitationKey,
      this.arabeTest,
      this.listOfChoisesArabeAnswers,
      this.answersDetailsAR});
  @override
  _FrancaisTestCarouselState createState() => _FrancaisTestCarouselState();
}

class _FrancaisTestCarouselState extends State<FrancaisTestCarousel> {
  DataFirebase dataFirebase = new DataFirebase();

  PageController _testFrancaisQuestionsPageController;
  int currentpage = 0;
  // to save candidate answers
  List<String> listOfChoisesFrancaisAnswers;
  // to save details of each answer
  Map<String, Map<String, int>> answersDetailsFR;
  // to save state of each answer in each question
  List<List<TestQuestionAnswer>> listOfTestQuestionAnswer;
  bool isLastQuestion = false;

  @override
  initState() {
    super.initState();
    listOfChoisesFrancaisAnswers = new List<String>();
    answersDetailsFR = new Map<String, Map<String, int>>();

    listOfTestQuestionAnswer = new List<List<TestQuestionAnswer>>();
    for (int i = 0; i < widget.francaisTest.numOfQuestions; i++) {
      listOfChoisesFrancaisAnswers.add(null);
      answersDetailsFR['Q' + (i + 1).toString()] = null;

      listOfTestQuestionAnswer.add(List<TestQuestionAnswer>.generate(
          widget.francaisTest.numOfTestAnswers,
          (index) => new TestQuestionAnswer(
                isSelected: false,
                /*questionAnswer: widget.francaisTest.answers[index]*/
              )));
    }

    _testFrancaisQuestionsPageController = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 1.0,
    );
  }

  @override
  dispose() {
    _testFrancaisQuestionsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          top: height > 600 ? height * 0.072 : height * 0.045,
          left: width > 350 ? width * 0.05 : width * 0.03,
          right: width > 350 ? width * 0.05 : width * 0.03),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Container(
          width: width,
          height: height > 600 ? height * 0.70 : height * 0.85,
          child: PageView.builder(
            //physics: NeverScrollableScrollPhysics(),
            controller: _testFrancaisQuestionsPageController,
            scrollDirection: Axis.horizontal,
            reverse: false,
            itemCount: widget.francaisTest.questions.length - 1,
            itemBuilder: (context, index) {
              /*List<TestQuestionAnswer> testQuestionAnswer =
                  List<TestQuestionAnswer>();*/

              index == widget.francaisTest.questions.length - 2
                  ? isLastQuestion = true
                  : isLastQuestion = false;
              Question question = Question.fromJson(widget
                  .francaisTest.questions['Question' + (index + 1).toString()]);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        (index + 1).toString() +
                            "/" +
                            widget.francaisTest.numOfQuestions.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFFF0000),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: question.question.length > 50 ? 15 : 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.francaisTest.answers.length,
                          itemBuilder: (ctx, indexVal) {
                            /*testQuestionAnswer.add(new TestQuestionAnswer(
                                questionAnswer: widget.test.answers[indexVal]));*/

                            bool selectedAnswer = ((listOfTestQuestionAnswer[
                                    currentpage])[indexVal])
                                .isSelected;
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              elevation: 20.0,
                              color: selectedAnswer
                                  ? isLastQuestion
                                      ? Color(0xFFFF0000)
                                      : Color(0xFF0513AD)
                                  : Color(0xFF3445FA),
                              child: ListTile(
                                title: Text(
                                  /*(indexVal + 1).toString() +
                                      ". " +*/
                                      widget.francaisTest.answers[indexVal],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      color: selectedAnswer
                                          ? Colors.white
                                          : Colors.white,
                                      fontWeight: selectedAnswer
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                                onTap: () {
                                  for (int i = 0;
                                      i < widget.francaisTest.numOfTestAnswers;
                                      i++) {
                                    if (indexVal == i) {
                                      ((listOfTestQuestionAnswer[currentpage])[i])
                                          .isSelected = true;
                                    } else {
                                      ((listOfTestQuestionAnswer[currentpage])[i])
                                          .isSelected = false;
                                    }
                                  }
                                  setState(() {
                                    listOfTestQuestionAnswer[currentpage] =
                                        listOfTestQuestionAnswer[currentpage];
                                    listOfChoisesFrancaisAnswers[currentpage] =
                                        (widget.francaisTest.answers[indexVal])
                                            .toLowerCase();
                                    answersDetailsFR[
                                        'Q' + (currentpage + 1).toString()] = {
                                      '${(widget.francaisTest.answers[indexVal]).toLowerCase()}':
                                          indexVal + 1
                                    };
                                  });
                                },
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: height > 600 ? height * 0.004 : height * 0.002,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: currentpage != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    color: Color(0xFF0513AD),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 15.0),
                                      child: Text(
                                        "Question Précédente",
                                        style: TextStyle(
                                            fontSize: currentpage !=
                                                    widget.francaisTest
                                                            .numOfQuestions -
                                                        1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.030
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.030,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () {
                                      _testFrancaisQuestionsPageController
                                          .previousPage(
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              curve: Curves.easeIn);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: width*0.01,
                                ),
                                Expanded(child: customButton()),
                              ],
                            )
                          : customButton(),
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

  Widget customButton() {
    return RaisedButton(
        elevation: 10.0,
        color: isLastQuestion ? Color(0xFFFF0000) : Color(0xFF0513AD),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
          child: Text(
            isLastQuestion
                ? widget.isFirstTime
                    ? "Commencer le test Arabe"
                    : "Découvrez les résultats"
                : "Question Suivant",
            style: TextStyle(
                fontSize: currentpage != widget.francaisTest.numOfQuestions - 1
                    ? MediaQuery.of(context).size.width * 0.030
                    : MediaQuery.of(context).size.width * 0.030,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: listOfChoisesFrancaisAnswers[currentpage] == null
            ? null
            : () {
                if (currentpage == widget.francaisTest.numOfQuestions - 1) {
                  if (widget.isFirstTime == true) {
                    // go to arabe test
                    print(answersDetailsFR);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeArabeCandidateTestApp(
                          isFirstTime: false,
                          invitationKey: widget.invitationKey,
                          listOfChoisesFrancaisAnswers:
                              listOfChoisesFrancaisAnswers,
                          arabeTest: widget.arabeTest,
                          francaisTest: widget.francaisTest,
                          answersDetailsFR: answersDetailsFR,
                          email: widget.email,
                        ),
                      ),
                    );
                  } else {
                    // finish the test
                    /*print(answersDetailsFR);
                                              print(widget.answersDetailsAR);*/

                    CandidateTestAnswer candidateTestAnswer =
                        new CandidateTestAnswer(
                            email: widget.email,
                            testID: widget.invitationKey.testID,
                            numOfTestAnswersAR:
                                widget.arabeTest.numOfTestAnswers,
                            numOfTestAnswersFR:
                                widget.francaisTest.numOfTestAnswers,
                            numOfArabeAnswers:
                                widget.listOfChoisesArabeAnswers.length,
                            numOfArabeQuestions:
                                widget.listOfChoisesArabeAnswers.length,
                            numOfFrancaisAnswers:
                                listOfChoisesFrancaisAnswers.length,
                            numOfFrancaisQuestions:
                                listOfChoisesFrancaisAnswers.length,
                            totalQuestionsEachAnsAR:
                                widget.arabeTest.numOfTestAnswers.toDouble(),
                            totalQuestionsEachAnsFR:
                                widget.francaisTest.numOfTestAnswers.toDouble(),
                            arabeAnswers: widget.listOfChoisesArabeAnswers,
                            ansDetailsAR: widget.answersDetailsAR,
                            francaisAnswers: listOfChoisesFrancaisAnswers,
                            ansDetailsFR: answersDetailsFR);

                    showInSnackBar(
                        "شكرا على تعاونك سيتم تحويلك الأن لحساب نتيجتك");

                    /*dataFirebase.sendData(
                        'CandidatesAnswers', candidateTestAnswer.toJson());*/

                    // update CandidatesKey
                    /*updateCandidatesKey().then((value) {
                      if (value == true) {
                        showInSnackBar(
                            "Merci! you will re-direct to see your results");
                      }
                    });*/

                    //Timer(const Duration(milliseconds: 2000), onClose);
                    Timer(const Duration(milliseconds: 2000),
                        () => onClose(candidateTestAnswer));
                  }
                } else {
                  // go to next page view but currentPage should != length-1
                  _testFrancaisQuestionsPageController.nextPage(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeIn);
                }
              });
  }

  Future<bool> updateCandidatesKey() async {
    bool isFound;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("CandidatesKey").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      InvitationKeys invitationKey = InvitationKeys.fromJson(a.data);

      if (invitationKey.email == widget.email &&
          invitationKey.key == widget.invitationKey.key) {
        a.reference.updateData(<String, Object>{'finished': true});

        isFound = true;
        break;
      }
    }

    return isFound;
  }

  void onClose(CandidateTestAnswer candidateTestAnswer) {
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowTestResult(
          email: widget.email,
          testID: widget.invitationKey.testID,
        ),
      ),
    );*/
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculateResult(
          candidateTestAnswer: candidateTestAnswer,
          /*email: widget.email,
          testID: widget.invitationKey.testID,*/
          invitationKey: widget.invitationKey,
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: new Text(value))));
  }
}

class TestQuestionAnswer {
  bool isSelected = false;

  TestQuestionAnswer({this.isSelected = false});
}

class CandidateTestAnswer {
  final String email;
  final String testID;
  final int numOfTestAnswersAR;
  final int numOfTestAnswersFR;
  final int numOfArabeAnswers;
  final int numOfFrancaisAnswers;
  final int numOfArabeQuestions;
  final int numOfFrancaisQuestions;
  final double totalQuestionsEachAnsAR;
  final double totalQuestionsEachAnsFR;
  final dynamic arabeAnswers;
  final dynamic francaisAnswers;
  final dynamic ansDetailsAR;
  final dynamic ansDetailsFR;

  CandidateTestAnswer(
      {this.email,
      this.testID,
      this.numOfTestAnswersAR,
      this.numOfTestAnswersFR,
      this.numOfArabeQuestions,
      this.numOfFrancaisQuestions,
      this.numOfArabeAnswers,
      this.numOfFrancaisAnswers,
      this.totalQuestionsEachAnsAR,
      this.totalQuestionsEachAnsFR,
      this.arabeAnswers,
      this.francaisAnswers,
      this.ansDetailsAR,
      this.ansDetailsFR});

  factory CandidateTestAnswer.fromJson(Map<dynamic, dynamic> json) {
    return CandidateTestAnswer(
      email: json['email'],
      testID: (json['TestInfo'])['testID'],
      numOfTestAnswersAR: (json['TestInfo'])['numOfTestAnswersAR'],
      numOfTestAnswersFR: (json['TestInfo'])['numOfTestAnswersFR'],
      numOfArabeAnswers: ((json['TestInfo'])['Arabe'])['numOfAnswers'],
      numOfArabeQuestions: ((json['TestInfo'])['Arabe'])['numOfQuestions'],
      numOfFrancaisAnswers: ((json['TestInfo'])['Francais'])['numOfAnswers'],
      numOfFrancaisQuestions:
          ((json['TestInfo'])['Francais'])['numOfQuestions'],
      totalQuestionsEachAnsAR:
          ((json['TestInfo'])['Arabe'])['totalQuestionsEachAnsAR'],
      totalQuestionsEachAnsFR:
          ((json['TestInfo'])['Francais'])['totalQuestionsEachAnsFR'],
      arabeAnswers: ((json['TestInfo'])['Arabe'])['Answers'],
      ansDetailsAR: ((json['TestInfo'])['Arabe'])['AnswersDetails'],
      francaisAnswers: ((json['TestInfo'])['Francais'])['Answers'],
      ansDetailsFR: ((json['TestInfo'])['Francais'])['AnswersDetails'],
    );
  }

  Map<String, Object> toJson() {
    return {
      'email': email,
      'TestInfo': {
        'testID': testID,
        'numOfTestAnswersAR': numOfTestAnswersAR,
        'numOfTestAnswersFR': numOfTestAnswersFR,
        'Arabe': {
          'numOfAnswers': numOfArabeAnswers,
          'numOfQuestions': numOfArabeQuestions,
          'totalQuestionsEachAnsAR': totalQuestionsEachAnsAR,
          'Answers': arabeAnswers,
          'AnswersDetails': ansDetailsAR
        },
        'Francais': {
          'numOfAnswers': numOfFrancaisAnswers,
          'numOfQuestions': numOfFrancaisQuestions,
          'totalQuestionsEachAnsFR': totalQuestionsEachAnsFR,
          'Answers': francaisAnswers,
          'AnswersDetails': ansDetailsFR
        }
      }
    };
  }
}
