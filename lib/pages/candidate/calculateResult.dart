import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/chooseTestLanguage.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/candidate/francaisCandidateTest.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'watchResult.dart';

class CalculateResult extends StatefulWidget {
  /*final String email;
  final String testID;*/
  final InvitationKeys invitationKey;
  final CandidateTestAnswer candidateTestAnswer;
  CalculateResult(
      {this.candidateTestAnswer,
      /* this.email, this.testID,*/ this.invitationKey});

  @override
  _CalculateResultState createState() => _CalculateResultState();
}

class _CalculateResultState extends State<CalculateResult> {
  DataFirebase dataFirebase = new DataFirebase();

  final Map<String, int> ansScoreAR = {
    'كن سريعا': 0,
    'قم بمجهود': 0,
    'كن قويا': 0,
    'كن مثاليا': 0,
    'ارضي الاخر': 0,
  };

  final Map<String, int> ansScoreFR = {
    'depeche toi': 0,
    'Fais des efforts': 0,
    'sois fort': 0,
    'sois parfait': 0,
    'fais plaisir': 0
  };

  List colors = [
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.purple
  ];

  int maxValueAR = 0;
  int maxValueFR = 0;

  String maxValueARIndex = '';
  String maxValueFRIndex = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool calculating, firstTime;

  @override
  void initState() {
    calculating = false;
    firstTime = true;
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        calculating = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("حساب النتائج"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0513AD),
      ),
      body: calculating == false
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("يتم حساب نتيجتك الان من فضلك انتظر"),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator()
              ],
            ))
          : calculateResult(),
    );
  }

  Widget calculateResult() {
    for (int i = 1; i <= widget.candidateTestAnswer.numOfTestAnswersAR; i++) {
      double countEachQuestion =
          widget.candidateTestAnswer.totalQuestionsEachAnsAR;
      int counter = i;
      //String ansName = ansScoreAR.keys.elementAt(i-1);

      int score = 0;
      while (counter <= widget.candidateTestAnswer.numOfArabeQuestions) {
        Map<String, dynamic> ansMap = (widget
            .candidateTestAnswer.ansDetailsAR['Q' + (counter).toString()]);
        score += (ansMap.values.first);
        counter += countEachQuestion.toInt();
      }
      //print(score);
      ansScoreAR[ansScoreAR.keys.elementAt(i - 1)] = score;
    }

    for (int i = 1; i <= widget.candidateTestAnswer.numOfTestAnswersFR; i++) {
      double countEachQuestion =
          widget.candidateTestAnswer.totalQuestionsEachAnsFR;
      int counter = i;

      int score = 0;
      while (counter <= widget.candidateTestAnswer.numOfFrancaisQuestions) {
        Map<String, dynamic> ansMap = (widget
            .candidateTestAnswer.ansDetailsFR['Q' + (counter).toString()]);
        score += (ansMap.values.first);
        counter += countEachQuestion.toInt();
      }
      //print(score);
      ansScoreFR[ansScoreFR.keys.elementAt(i - 1)] = score;
    }

    maxValueAR = ansScoreAR.values.elementAt(0);
    maxValueFR = ansScoreFR.values.elementAt(0);
    maxValueARIndex = ansScoreAR.keys.elementAt(0);
    maxValueFRIndex = ansScoreFR.keys.elementAt(0);

    double percentageAR = 0.0;
    double percentageFR = 0.0;

    int counterAR = 0;
    int indexAR = 0;
    int counterFR = 0;
    int indexFR = 0;
    ansScoreAR.forEach((key, value) {
      percentageAR += value.toDouble();
      if (value > maxValueAR) {
        maxValueAR = value;
        maxValueARIndex = key;
        indexAR = counterAR;
      }
      counterAR += 1;
    });

    ansScoreFR.forEach((key, value) {
      percentageFR += value.toDouble();
      if (value > maxValueFR) {
        maxValueFR = value;
        maxValueFRIndex = key;
        indexFR = counterFR;
      }
      counterFR += 1;
    });

    /*print(ansScoreFR);
    print(ansScoreAR);
    print(maxValueAR);
    print(maxValueFR);
    print(maxValueARIndex);
    print(maxValueFRIndex);
    print(counterAR);
    print(indexAR);
    print(counterFR);
    print(indexFR);*/

    Widget msgWidget;
    if (indexAR == indexFR) {
      // to check all another patterns are less than 30
      bool checkARScore = false;
      bool checkFRScore = false;
      for (int i = 0; i < ansScoreAR.length; i++) {
        if (i == indexAR)
          continue;
        else {
          int arScore = ansScoreAR[ansScoreAR.keys.elementAt(i)];
          double percentageARScore = double.parse(
              ((arScore.toDouble() / percentageAR) * 100).toStringAsFixed(1));
          if (percentageARScore > 30) {
            // then there is pattern is larger than 30 in AR
            checkARScore = true;
            break;
          }
        }
      }

      for (int i = 0; i < ansScoreFR.length; i++) {
        if (i == indexFR)
          continue;
        else {
          int frScore = ansScoreFR[ansScoreFR.keys.elementAt(i)];
          double percentageFRScore = double.parse(
              ((frScore.toDouble() / percentageFR) * 100).toStringAsFixed(1));
          if (percentageFRScore > 30) {
            // then there is pattern is larger than 30 in FR
            checkFRScore = true;
            break;
          }
        }
      }

      if (checkARScore == false && checkFRScore == false) {
        if (firstTime == true) {
          // save results in database
          dataFirebase.sendData(
              'CandidatesAnswers', widget.candidateTestAnswer.toJson());

          // update CandidatesKey
          updateCandidatesKey();
        }

        msgWidget = matchMsg(percentageAR, percentageFR);
      } else {
        msgWidget = notMatchMsg();
      }
    } else {
      msgWidget = notMatchMsg();
      /*showInSnackBar(
          "من الواضح ان نتائجك غير متساوية لذلك ستقوم بإعادة الأمتحان مرة اخري");*/
    }
    if (firstTime == true) print("goodbye");

    // to prevent save new data in database when refresh stack or page
    setState(() {
      firstTime = false;
    });
    return msgWidget;
  }

  void updateCandidatesKey() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("CandidatesKey").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      InvitationKeys invitationKey = InvitationKeys.fromJson(a.data);

      if (invitationKey.email == widget.invitationKey.email &&
          invitationKey.key == widget.invitationKey.key) {
        a.reference.updateData(<String, Object>{'finished': true});

        break;
      }
    }
  }

  Widget matchMsg(double percentageAR, double percentageFR) {
    List<BarChartGroupData> listOfItems = [];
    for (int i = 0; i < ansScoreAR.length; i++) {
      int arScore = ansScoreAR[ansScoreAR.keys.elementAt(i)];
      int frScore = ansScoreFR[ansScoreFR.keys.elementAt(i)];
      var item = makeGroupData(i, (arScore.toDouble() / percentageAR) * 100,
          (frScore.toDouble() / percentageFR) * 100, colors[0], colors[1]);
      listOfItems.add(item);
    }
    final raw = listOfItems;
    final showBarGroups = raw;

    return buildGraph(showBarGroups);
  }

  Widget notMatchMsg() {
    return Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "من الواضح ان نتائجك غير متساوية لذلك ستقوم بإعادة الأمتحان مرة اخري",
                style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
                elevation: 10.0,
                color: Colors.red[500],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 10.0),
                  child: Text(
                    "إعادة الامتحان",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseTestLanguage(
                        email: widget.invitationKey.email,
                        invitationKey: widget.invitationKey,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget buildGraph(List<BarChartGroupData> showBarGroups) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 10.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              color: Color(0xFF0513AD),
              child: Column(children: <Widget>[
                Text(
                  "المقارنة بين نتيجة الاختبارين",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle, color: colors[0]),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Resultats en Francais",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.06,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle, color: colors[1]),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "النتائج بالعربية",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                        ),
                      ],
                    ),
                  ],
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => index)
                      .map((index) => Expanded(
                          flex: 1,
                          child: showIndicator(ansScoreAR.keys.elementAt(index),
                              ansScoreFR.keys.elementAt(index), Colors.pink)))
                      .toList(),
                ),*/
                SizedBox(
                  height: 10.0,
                ),
                Expanded(child: buildBarChart(showBarGroups))
              ])),
          SizedBox(
            height: 5.0,
          ),
          /*Expanded(
            child: RaisedButton(
              elevation: 20.0,
              color: Colors.red[700],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "إكتشف شخصيتك حسب نمطك المهيمن".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {},
            ),
          )*/
          Card(
            elevation: 20,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "فيما يلى بعض السبل لتفسير النتائج :",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3445FA)),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: "نسبة اقل من 30%  ",
                            style: TextStyle(
                                color: Color(0xFF3445FA),
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text:
                                      "تشير إلى أن النمط المعني ليس موجوداً بالفعل فى الفرد , نقول ان الفرد لا يعرف كيف يتصرف وفق هذا النمط",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0)),
                            ])),
                    SizedBox(
                      height: 25.0,
                    ),
                    RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: "نسبة تتراوح بين 30% و 70%  ",
                            style: TextStyle(
                                color: Color(0xFF3445FA),
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text:
                                      "تشير إلى وجود النمط المعنى فى الفرد لكن الفرد لا يحب القيام بذلك , كما انه ليس هذا ما يتم التعبير عنه بقوة فى حالات التوتر",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0)),
                            ])),
                    SizedBox(
                      height: 25.0,
                    ),
                    RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: "نسبة أكبر من 70%  ",
                            style: TextStyle(
                                color: Color(0xFF3445FA),
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text:
                                      "تشير إلى أن النمط حاضر بقوة عند الفرد, وهذا النمط هو السائد فى حالات التوتر والضغط , وطريقة عمل هذا الفرد تمشي وفق هذا النمط",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0)),
                            ])),
                    SizedBox(
                      height: 35.0,
                    ),
                    Text(
                      "إذا كانت النسب عالية جداً, فإن الترجيح ضروري",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.18),
            child: RaisedButton(
              elevation: 20.0,
              color: Color(0xFF0513AD),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "إكتشف شخصيتك حسب نمطك المهيمن".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                /*print(maxValueARIndex);
                print(maxValueFRIndex);*/
                setState(() {
                  firstTime = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchCandidateResult(
                      pattern: maxValueARIndex,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showIndicator(String text1, String text2, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Transform.rotate(
            angle: pi / 4,
            child: Text(text1,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 1.0),
                    stops: [0.0, 1.0],
                    colors: [colors[0], colors[1]])),
          ),
          SizedBox(
            height: 10.0,
          ),
          Transform.rotate(
            angle: pi / 4,
            child: Text(text2,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildBarChart(var showBarGroup) {
    return Card(
      elevation: 25.0,
      shadowColor: Colors.teal[100],
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: BarChart(
          BarChartData(
              barGroups: showBarGroup,
              backgroundColor: Colors.transparent,
              maxY: maxValueAR > maxValueFR
                  ? maxValueAR.toDouble() + 2.0
                  : maxValueFR.toDouble() + 2.0,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(
                  border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
                left: BorderSide(color: Colors.black, width: 2.0),
              )),
              axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                    showTitle: true,
                    titleText: 'الدرجات',
                    margin: 8.0,
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800])),
                bottomTitle: AxisTitle(
                    showTitle: true,
                    titleText: 'الأنماط',
                    margin: 8.0,
                    textStyle: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800])),
              ),
              gridData: FlGridData(
                show: true,
              ),
              barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipBottomMargin: 0.0,
                      tooltipPadding: EdgeInsets.zero)),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      color: Colors.teal[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                  margin: 8.0,
                  getTitles: (value) =>
                      '${ansScoreAR.keys.elementAt(value.toInt())}',
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      color: Colors.teal[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                  margin: 8.0,
                  getTitles: (value) {
                    if (value == 0)
                      return value.toString();
                    else if (value == 10)
                      return value.toString();
                    else if (value == 20)
                      return value.toString();
                    else if (value == 30)
                      return value.toString();
                    else if (value == 40)
                      return value.toString();
                    else if (value == 50)
                      return value.toString();
                    else if (value == 60)
                      return value.toString();
                    else if (value == 70)
                      return value.toString();
                    else if (value == 80)
                      return value.toString();
                    else if (value == 90)
                      return value.toString();
                    else if (value == 100)
                      return value.toString();
                    else
                      return '';
                  },
                ),
              )),
          swapAnimationDuration: const Duration(seconds: 3),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, Color c1, Color c2) {
    return BarChartGroupData(
        barsSpace: 2.0,
        x: x,
        barRods: [
          BarChartRodData(
              y: double.parse(y1.toStringAsFixed(1)),
              color: c1,
              width: MediaQuery.of(context).size.width * 0.055,
              borderRadius: BorderRadius.circular(0.0)),
          BarChartRodData(
              y: double.parse(y2.toStringAsFixed(1)),
              color: c2,
              width: MediaQuery.of(context).size.width * 0.055,
              borderRadius: BorderRadius.circular(0.0))
        ],
        showingTooltipIndicators: 0 > 1 ? [0] : [1]);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: new Text(value))));
  }
}
