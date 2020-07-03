import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/candidate/calculateResult.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/candidate/francaisCandidateTest.dart';
import 'package:tesapp/pages/candidate/testResult.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/invitation_test.dart';

class MakeArabeCandidateTestApp extends StatelessWidget {
  final String email;
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  final List<String> listOfChoisesFrancaisAnswers;
  final Map<String, Map<String, int>> answersDetailsFR;
  final Test arabeTest;
  final Test francaisTest;
  MakeArabeCandidateTestApp(
      {this.email,
      this.isFirstTime = true,
      this.invitationKey,
      this.listOfChoisesFrancaisAnswers,
      this.answersDetailsFR,
      this.arabeTest,
      this.francaisTest});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (BuildContext context) {
              return ArabeCandidateTest(
                email: email,
                isFirstTime: isFirstTime,
                invitationKey: invitationKey,
                listOfChoisesFrancaisAnswers: listOfChoisesFrancaisAnswers,
                answersDetailsFR: answersDetailsFR,
                arabeTest: arabeTest,
                francaisTest: francaisTest,
              );
            },
          ),
        );
      },
    );
  }
}

class ArabeCandidateTest extends StatefulWidget {
  final String email;
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  final List<String> listOfChoisesFrancaisAnswers;
  final Map<String, Map<String, int>> answersDetailsFR;
  final Test arabeTest;
  final Test francaisTest;
  ArabeCandidateTest(
      {this.email,
      this.isFirstTime = true,
      this.invitationKey,
      this.listOfChoisesFrancaisAnswers,
      this.answersDetailsFR,
      this.arabeTest,
      this.francaisTest});
  @override
  _ArabeCandidateTestState createState() => _ArabeCandidateTestState();
}

class _ArabeCandidateTestState extends State<ArabeCandidateTest> {
  Test francaisTest = new Test();
  Test arabeTest = new Test();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white60,
        appBar: AppBar(
          title: Text("الأختبار"),
          automaticallyImplyLeading: widget.isFirstTime ? true : false,
          centerTitle: true,
          backgroundColor: Color(0xFF0513AD),
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
                        int counterTests = 0;
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          if (counterTests == 2) break;

                          var a = snapshot.data.documents[i];
                          Test tempTest = Test.fromJson(a.data);
                          if (tempTest.testID == widget.invitationKey.testID) {
                            if (tempTest.language == 'ar') {
                              counterTests++;
                              arabeTest = tempTest;
                            } else {
                              counterTests++;
                              francaisTest = tempTest;
                            }
                            msgWidget = ArabeTestCarousel(
                              arabeTest: arabeTest,
                              isFirstTime: widget.isFirstTime,
                              invitationKey: widget.invitationKey,
                              francaisTest: francaisTest,
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
            : ArabeTestCarousel(
                arabeTest: widget.arabeTest,
                francaisTest: widget.francaisTest,
                isFirstTime: widget.isFirstTime,
                invitationKey: widget.invitationKey,
                listOfChoisesFrancaisAnswers:
                    widget.listOfChoisesFrancaisAnswers,
                answersDetailsFR: widget.answersDetailsFR,
                email: widget.email,
                scaffoldKey: _scaffoldKey,
              ),
      ),
    );
  }
}

class ArabeTestCarousel extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String email;
  final Test francaisTest;
  final Test arabeTest;
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  final List<String> listOfChoisesFrancaisAnswers;
  final Map<String, Map<String, int>> answersDetailsFR;
  ArabeTestCarousel(
      {this.scaffoldKey,
      this.email,
      this.arabeTest,
      this.francaisTest,
      this.isFirstTime,
      this.invitationKey,
      this.listOfChoisesFrancaisAnswers,
      this.answersDetailsFR});
  @override
  _ArabeTestCarouselState createState() => _ArabeTestCarouselState();
}

class _ArabeTestCarouselState extends State<ArabeTestCarousel> {
  DataFirebase dataFirebase = new DataFirebase();

  PageController _testArabeQuestionsPageController;
  int currentpage = 0;
  List<String> listOfChoisesArabeAnswers;
  Map<String, Map<String, int>> answersDetailsAR;
  List<List<TestQuestionAnswer>> listOfTestQuestionAnswer;
  bool isLastQuestion = false;

  @override
  initState() {
    super.initState();
    listOfChoisesArabeAnswers = new List<String>();
    answersDetailsAR = new Map<String, Map<String, int>>();

    listOfTestQuestionAnswer = new List<List<TestQuestionAnswer>>();
    for (int i = 0; i < widget.arabeTest.numOfQuestions; i++) {
      listOfChoisesArabeAnswers.add(null);
      answersDetailsAR['Q' + (i + 1).toString()] = null;

      listOfTestQuestionAnswer.add(List<TestQuestionAnswer>.generate(
          widget.arabeTest.numOfTestAnswers,
          (index) => new TestQuestionAnswer(
                isSelected: false,
                /*questionAnswer: widget.francaisTest.answers[index]*/
              )));
    }

    _testArabeQuestionsPageController = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 1.0,
    );
  }

  @override
  dispose() {
    _testArabeQuestionsPageController.dispose();
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
            controller: _testArabeQuestionsPageController,
            scrollDirection: Axis.horizontal,
            reverse: false,
            itemCount: widget.arabeTest.questions.length - 1,
            itemBuilder: (context, index) {
              /*List<TestQuestionAnswer> testQuestionAnswer =
                  List<TestQuestionAnswer>();*/

              index == widget.arabeTest.questions.length - 2
                  ? isLastQuestion = true
                  : isLastQuestion = false;
              Question question = Question.fromJson(widget
                  .arabeTest.questions['Question' + (index + 1).toString()]);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //(index + 1).toString() + ". " +
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        (index + 1).toString() +
                            "/" +
                            widget.arabeTest.numOfQuestions.toString(),
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
                          itemCount: widget.arabeTest.answers.length,
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
                                  widget.arabeTest.answers[indexVal],
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
                                      i < widget.arabeTest.numOfTestAnswers;
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
                                    listOfChoisesArabeAnswers[currentpage] =
                                        widget.arabeTest.answers[indexVal];
                                    answersDetailsAR[
                                        'Q' + (currentpage + 1).toString()] = {
                                      '${(widget.arabeTest.answers[indexVal]).toLowerCase()}':
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
                          //height: height * 0.075,
                          alignment: Alignment.center,
                          child: currentpage != 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(child: customButton()),
                                    SizedBox(
                                      width: width > 350 ? width*0.03 : width*0.01,
                                    ),
                                    Expanded(
                                      child: RaisedButton(
                                        elevation: 10.0,
                                        color: Color(0xFF0513AD),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10.0),
                                          child: Text(
                                            "السؤال السابق".toUpperCase(),
                                            style: TextStyle(
                                                fontSize: currentpage !=
                                                        widget.arabeTest
                                                                .numOfQuestions -
                                                            1
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.030,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onPressed: () {
                                          _testArabeQuestionsPageController
                                              .previousPage(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.easeIn);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : customButton()),
                    )
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Text(
            isLastQuestion
                ? widget.isFirstTime
                    ? "ابدأ الأختبار بالفرنسي".toUpperCase()
                    : "إكتشف النتائج".toUpperCase()
                : "السؤال التالى".toUpperCase(),
            style: TextStyle(
                fontSize: currentpage != widget.arabeTest.numOfQuestions - 1
                    ? MediaQuery.of(context).size.width * 0.045
                    : MediaQuery.of(context).size.width * 0.030,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: listOfChoisesArabeAnswers[currentpage] == null
            ? null
            : () {
                if (currentpage == widget.arabeTest.numOfQuestions - 1) {
                  if (widget.isFirstTime == true) {
                    // go to francais test
                    print(answersDetailsAR);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeFrancaisCandidateTest(
                          isFirstTime: false,
                          invitationKey: widget.invitationKey,
                          listOfChoisesArabeAnswers: listOfChoisesArabeAnswers,
                          francaisTest: widget.francaisTest,
                          arabeTest: widget.arabeTest,
                          answersDetailsAR: answersDetailsAR,
                          email: widget.email,
                        ),
                      ),
                    );
                  } else {
                    // finish the test
                    /*print(answersDetailsAR);
                                            print(widget.answersDetailsFR);*/

                    CandidateTestAnswer candidateTestAnswer =
                        new CandidateTestAnswer(
                            email: widget.email,
                            testID: widget.invitationKey.testID,
                            numOfTestAnswersAR:
                                widget.arabeTest.numOfTestAnswers,
                            numOfTestAnswersFR:
                                widget.francaisTest.numOfTestAnswers,
                            numOfArabeAnswers: listOfChoisesArabeAnswers.length,
                            numOfArabeQuestions:
                                listOfChoisesArabeAnswers.length,
                            numOfFrancaisAnswers:
                                widget.listOfChoisesFrancaisAnswers.length,
                            numOfFrancaisQuestions:
                                widget.listOfChoisesFrancaisAnswers.length,
                            totalQuestionsEachAnsAR:
                                widget.arabeTest.numOfTestAnswers.toDouble(),
                            totalQuestionsEachAnsFR:
                                widget.francaisTest.numOfTestAnswers.toDouble(),
                            arabeAnswers: listOfChoisesArabeAnswers,
                            ansDetailsAR: answersDetailsAR,
                            francaisAnswers:
                                widget.listOfChoisesFrancaisAnswers,
                            ansDetailsFR: widget.answersDetailsFR);

                    showInSnackBar(
                        "شكرا على تعاونك سيتم تحويلك الأن لحساب نتيجتك");

                    /*dataFirebase.sendData(
                        'CandidatesAnswers', candidateTestAnswer.toJson());*/

                    /*updateCandidatesKey().then((value) {
                      if (value == true) {
                        showInSnackBar(
                            "Merci! you will re-direct to see your results");
                      }
                    });*/

                    Timer(const Duration(milliseconds: 2000),
                        () => onClose(candidateTestAnswer));
                  }
                } else {
                  // go to next page view but currentPage should != length-1
                  _testArabeQuestionsPageController.nextPage(
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
