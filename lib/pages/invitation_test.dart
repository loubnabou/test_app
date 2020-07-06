import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/home.dart';
import 'package:tesapp/pages/sendmail.dart';
import 'package:tesapp/widgets/provider_widget.dart';

class TestInvitation extends StatefulWidget {
  final List<String> emailsList;
  TestInvitation({this.emailsList});
  @override
  _TestInvitationState createState() => _TestInvitationState();
}

class _TestInvitationState extends State<TestInvitation> {
  List<Test> _testLists;
  Test selectedTest;
  FirebaseUser user;
  GlobalKey<ScaffoldState> _scaffoldKey;
  DataFirebase dataFirebase = new DataFirebase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    selectedTest = null;
    _testLists = new List<Test>();
    _loadTests();
  }

  _loadTests() async {
    user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('Coachs').getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.data['coachName'] == user.email) {
        setState(() {
          _testLists.add(new Test.fromJson(a.data));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Choose Test"),
        backgroundColor: Color(0xFF0513AD),
      ),
      body: _testLists.length != 0
          ? ListView.builder(
              itemCount: _testLists.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        RadioListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              'Title: ' + _testLists[index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text('Subject: ' + _testLists[index].subject),
                            value: _testLists[index],
                            groupValue: selectedTest,
                            onChanged: (val) {
                              setState(() {
                                selectedTest = val;
                              });
                            })
                      ],
                    ),
                  ),
                );
              })
          : Center(),
      floatingActionButton: Opacity(
        opacity: selectedTest != null ? 1.0 : 0.0,
        child: FloatingActionButton(
            backgroundColor: Color(0xFF0513AD),
            child: Icon(Icons.email),
            onPressed: () {
              for (int i = 0; i < widget.emailsList.length; i++) {
                String key = Utils.createCryptoRandomString();
                InvitationKeys invitationKey = new InvitationKeys(
                    invitedBy: user.email,
                    testID: selectedTest.testID,
                    email: widget.emailsList[i],
                    key: key);

                dataFirebase.sendData("CandidatesKey", invitationKey.toJson());
                final msg =
                    SendEmails.sendMail(widget.emailsList, user.email, key);
                msg.then((value) {
                  showInSnackBar(
                      'Message sent successfully to ${widget.emailsList[i]}',
                      widget.emailsList.length);
                }).catchError((error) => showInSnackBar(
                    'There are some errors happen, please try again', 1));
              }

              Timer(
                  Duration(
                      milliseconds: ((widget.emailsList.length) + 1) * 1500),
                  onClose);
            }),
      ),
    );
  }

  void onClose() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          result: user,
        ),
      ),
    );
  }

  void showInSnackBar(String value, int size) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(milliseconds: size * 1200),
    ));
  }
}

class Utils {
  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 4]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }
}

class InvitationKeys {
  final String invitedBy;
  final String testID;
  final String email;
  final String key;
  final bool finished;
  InvitationKeys(
      {this.invitedBy,
      this.finished = false,
      this.testID,
      this.email,
      this.key});

  factory InvitationKeys.fromJson(Map<dynamic, dynamic> json) {
    return InvitationKeys(
        invitedBy: json['invitedBy'],
        testID: json['testID'],
        finished: json['finished'],
        email: (json['Key'])['email'],
        key: (json['Key'])['key']);
  }

  Map<String, Object> toJson() {
    return {
      'invitedBy': invitedBy,
      'finished': finished,
      'testID': testID,
      'Key': {'email': email, 'key': key}
    };
  }
}
