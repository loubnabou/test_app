import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/candidateContinueInfo.dart';
import 'package:tesapp/pages/home.dart';
import 'package:tesapp/services/auth_service.dart';

class IDOfCoach extends StatefulWidget {
  final FirebaseUser user;
  final String actionType;
  IDOfCoach({this.user, this.actionType});
  @override
  _IDOfCoachState createState() => _IDOfCoachState();
}

class _IDOfCoachState extends State<IDOfCoach> {
  final primaryColor = const Color(0xFF7a34c5);
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController idCoach = new TextEditingController();
  String _id;
  String warning;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        color: Color(0xFF0513AD),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            Text(
              "Enter Your ID",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Form(
              key: formKey,
              child: TextFormField(
                controller: idCoach,
                validator: PasswordValidator.validate,
                style: TextStyle(fontSize: 22.0),
                decoration: InputDecoration(
                  hintText: "Your ID",
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0)),
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 10.0, top: 10.0),
                ),
                onSaved: (value) {
                  _id = value;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Colors.white,
                textColor: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Continue",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                  ),
                ),
                onPressed: submit,
              ),
            ),
            FlatButton(
              child: Text(
                "Don't have an ID, be candidate and click now",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CandidateContinueInfo(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (validate()) {
      // continue to coach page
      try {
        _checkID();
      } catch (e) {
        setState(() {
          warning = e.message;
        });
      }
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _checkID() async {
    bool isFound = false;

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Users").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (widget.actionType == 'sign_up') {
        if ((a.data['user'])['userType'] == 'coach') {
          if ((a.data['user'])['id'] == _id) {
            isFound = true;
            /*a.reference.updateData(<String, Object>{
          'user' : {
            'userType' : 'coach'
          } 
        });*/

            a.reference.setData({
              'user': {'email': widget.user.email}
            }, merge: true);

            break;
          }
        }
      } else {
        if ((a.data['user'])['userType'] == 'coach') {
          if ((a.data['user'])['id'] == _id &&
              (a.data['user'])['email'] == widget.user.email) {
            isFound = true;
            break;
          }
        }
      }
    }

    if (isFound) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'userType';
      final value = 'coach';
      prefs.setString(key, value);
      //print(value);

      final key2 = 'userID';
      final value2 = _id;
      prefs.setString(key2, value2);
      //('value is $value2');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(result: widget.user),
        ),
      );
      idCoach.clear();
    } else {
      showInSnackBar("Uncorrect ID, try again, or be candidate");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
