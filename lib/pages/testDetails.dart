import 'package:flutter/material.dart';

import 'formsFrancais.dart';

class TestDetails extends StatefulWidget {
  final Test test;
  TestDetails({this.test});
  @override
  _TestDetailsState createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les Tests"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(widget.test.title,
                style: TextStyle(
                    fontSize: 25,
                    wordSpacing: 5.0,
                    letterSpacing: 5.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            Text(widget.test.subject,
                style: TextStyle(
                  fontSize: 18,
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getAnswers(widget.test.answers),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.test.questions.length - 1,
                itemBuilder: (context, index) {
                  Map<String, Object> result = widget
                      .test.questions['Question' + (index + 1).toString()];
                  print(result);
                  return ListTile(
                    title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text((index + 1).toString() + '. ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(result['question'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  List<Widget> _getAnswers(var answer) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < answer.length; i++) {
      list.add(
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text((i + 1).toString() + '. ' + answer[i],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return list;
  }
}
