import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/sendmail.dart';
import 'francaisCandidateTest.dart';
import 'package:fl_chart/fl_chart.dart';
import '../indicator.dart';

class ShowTestResult extends StatelessWidget {
  final String email;
  final String testID;
  ShowTestResult({this.email, this.testID});

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
    Colors.blue,
    Colors.orangeAccent,
    Colors.pink,
    Colors.teal,
    Colors.purple
  ];

  double percentageAR = 0.0;
  double percentageFR = 0.0;

  int maxValueAR = 0;
  int maxValueFR = 0;

  String maxValueARIndex = '';
  String maxValueFRIndex = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Resultants"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            Firestore.instance.collection("CandidatesAnswers").getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Your results is being calculating, Be patient'),
                  CircularProgressIndicator()
                ],
              ));
            default:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                Widget msgWidget;
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  var a = snapshot.data.documents[i];
                  CandidateTestAnswer candidateTestAnswer =
                      CandidateTestAnswer.fromJson(a.data);
                  if (candidateTestAnswer.email == email &&
                      candidateTestAnswer.testID == testID) {
                    bool completed = false;
                    while (completed == false) {
                      msgWidget = CircularProgressIndicator();
                      for (int i = 1;
                          i <= candidateTestAnswer.numOfArabeAnswers;
                          i++) {
                        double countEachQuestion =
                            candidateTestAnswer.totalQuestionsEachAnsAR;
                        int counter = i;
                        //String ansName = ansScoreAR.keys.elementAt(i-1);

                        int score = 0;
                        while (counter <=
                            candidateTestAnswer.numOfArabeQuestions) {
                          Map<String, dynamic> ansMap = (candidateTestAnswer
                              .ansDetailsAR['Q' + (counter).toString()]);
                          score += (ansMap.values.first);
                          counter += countEachQuestion.toInt();
                        }
                        //print(score);
                        ansScoreAR[ansScoreAR.keys.elementAt(i - 1)] = score;
                      }

                      for (int i = 1;
                          i <= candidateTestAnswer.numOfFrancaisAnswers;
                          i++) {
                        double countEachQuestion =
                            candidateTestAnswer.totalQuestionsEachAnsFR;
                        int counter = i;

                        int score = 0;
                        while (counter <=
                            candidateTestAnswer.numOfFrancaisQuestions) {
                          Map<String, dynamic> ansMap = (candidateTestAnswer
                              .ansDetailsFR['Q' + (counter).toString()]);
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

                      ansScoreAR.forEach((key, value) {
                        percentageAR += value.toDouble();
                        if (value > maxValueAR) {
                          maxValueAR = value;
                          maxValueARIndex = key;
                        }
                      });

                      ansScoreFR.forEach((key, value) {
                        percentageFR += value.toDouble();
                        if (value > maxValueFR) {
                          maxValueFR = value;
                          maxValueFRIndex = key;
                        }
                      });
                      

                      completed = !completed;
                    }
                    /*
                    print(ansScoreAR);
                    print(ansScoreFR);*/
                    
                    List<BarChartGroupData> listOfItems = [];
                    for (int i = 0; i < ansScoreAR.length; i++) {
                      int arScore = ansScoreAR[ansScoreAR.keys.elementAt(i)];
                      int frScore = ansScoreFR[ansScoreFR.keys.elementAt(i)];
                      var item = makeGroupData(i, arScore.toDouble(),
                          frScore.toDouble(), colors[0], colors[1]);
                      listOfItems.add(item);
                    }
                    final raw = listOfItems;
                    final showBarGroups = raw;

                    msgWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 10.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              color: Colors.teal,
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    showIndicator(
                                        'كن سريعا', 'depeche toi', Colors.pink),
                                    showIndicator('قم بمجهود',
                                        'fais des efforts', Colors.pink),
                                    showIndicator(
                                        'كن قويا', 'sois fort', Colors.pink),
                                    showIndicator('كن مثاليا', 'sois parfait',
                                        Colors.pink),
                                    showIndicator('ارضي الآخر', 'fais plaisir',
                                        Colors.pink)
                                  ],
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                Expanded(child: buildBarChart(showBarGroups))
                              ])),
                          SizedBox(
                            height: 25.0,
                          ),
                          /*
                          Expanded(
                              flex: 6,
                              child: buildPieChart(
                                  ansScoreFR, percentageFR, 'Le Resultants')),
                          SizedBox(
                            height: 10.0,
                          ),*/
                          Expanded(
                            child: RaisedButton(
                              elevation: 20.0,
                              color: Colors.red[700],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  "Save & Finish".toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 2.0,
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () {
                                /*
                                final msg = SendEmails.sendResultMail(
                                    email, 'owner@fcih.iq.com', 'Hello');
                                msg.then((value) {
                                  showInSnackBar(
                                      'Check your E-mail please, to show more about you');
                                }).catchError((error) => showInSnackBar(
                                    'There are some errors $error happen, please try again'));

                                Timer(const Duration(milliseconds: 2000),
                                    onClose);
                                    */
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    msgWidget = Container();
                  }
                }

                return Center(
                  child: msgWidget,
                );
              }
          }
        },
      ),
    );
  }

  void onClose() {
    print("Good Bye");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: const Duration(milliseconds: 1500),
    ));
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
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: color,
            ),
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
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: BarChart(BarChartData(
            barGroups: showBarGroup,
            maxY: maxValueAR > maxValueFR ? maxValueAR.toDouble() + 2.0 : maxValueFR.toDouble() + 2.0,
            alignment: BarChartAlignment.spaceEvenly,
            borderData: FlBorderData(
              border: Border(bottom: BorderSide(
                color: Colors.black,
                width: 2.0
              ),
              left: BorderSide(
                color: Colors.black,
                width: 2.0
              ),)
            ),
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: 'Scores',
                margin: 8.0,
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Patterns',
                margin: 8.0,
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
              ),
            ),
            gridData: FlGridData(
              show: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
                margin: 8.0,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'DEP';
                    case 1:
                      return 'Fais';
                    case 2:
                      return 'Sois';
                    case 3:
                      return 'Parfait';
                    case 4:
                      return 'Fais';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0),
                margin: 8.0,
                getTitles: (value) => value.toString(),
              ),
            ))),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, Color c1, Color c2) {
    return BarChartGroupData(barsSpace: 2.0, x: x, barRods: [
      BarChartRodData(y: y1, color: c1, width: 15.0, borderRadius: BorderRadius.circular(0.0)),
      BarChartRodData(y: y2, color: c2, width: 15.0, borderRadius: BorderRadius.circular(0.0))
    ]);
  }

  /*

  Widget buildPieChart(dynamic list, double percentage, String title) {
    int colorsIndex1 = -1;
    int colorsIndex2 = -1;
    List<int> listValues = [];
    List<String> listKeys = [];
    list.forEach((key, value) {
      listValues.add(value);
      listKeys.add(key);
    });

    return Card(
        elevation: 20.0,
        child: Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(title,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: <Widget>[
                      PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          centerSpaceRadius: double.nan,
                          sectionsSpace: 2.0,
                          // read about it in the below section
                          sections: listValues.map((item) {
                            colorsIndex1 += 1;
                            return PieChartSectionData(
                                titleStyle: TextStyle(
                                  fontSize: (((item / percentage)) * 100) < 20
                                      ? 13
                                      : 15.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                color: colors[colorsIndex1],
                                titlePositionPercentageOffset: 0.5,
                                value: item.toDouble(),
                                radius: 50,
                                title: (((item / percentage)) * 100)
                                        .toStringAsFixed(0) +
                                    '%');
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: listKeys.map((item) {
                            colorsIndex2 += 1;
                            return SizedBox(
                              width: double.infinity,
                              height: 20.0,
                              //child: showIndicator(item, colors[colorsIndex2]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
  */
}

class Result {
  String result;
  double score;

  Result(this.result, this.score);
}
