import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/candidate/testResult.dart';
import 'package:tesapp/pages/candidate/welcomeScreen.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'package:tesapp/services/auth_service.dart';

class CandidateContinueInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CandidateInfo(),
    );
  }
}

class CandidateInfo extends StatefulWidget {
  @override
  _CandidateInfoState createState() => _CandidateInfoState();
}

class _CandidateInfoState extends State<CandidateInfo> {
  final primaryColor = const Color(0xFF7a34c5);
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController candidateEmail = new TextEditingController();
  TextEditingController candidatePassword = new TextEditingController();
  String _email;
  String _password;
  String warning;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        color: primaryColor,
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "Enter Your E-mail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                TextFormField(
                  controller: candidateEmail,
                  validator: EmailValidator.validate,
                  style: TextStyle(fontSize: 22.0),
                  decoration: InputDecoration(
                    hintText: "Your E-Mail",
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 0.0)),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                  ),
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Text(
                  "Enter Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                TextFormField(
                  controller: candidatePassword,
                  validator: (val) {
                    if (val.isEmpty)
                      return 'Cannot be empty';
                    else
                      return null;
                  },
                  style: TextStyle(fontSize: 22.0),
                  decoration: InputDecoration(
                    hintText: "Password e.g. ejHk==",
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 0.0)),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 10.0, top: 10.0),
                  ),
                  onSaved: (value) {
                    _password = value;
                  },
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
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w300),
                      ),
                    ),
                    onPressed: submit,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "Aren't candidate?, be coach and click now",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (validate()) {
      // continue to coach page
      try {
        _checkEmail();
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

  void _checkEmail() async {
    bool isFound = false;

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Users").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if ((a.data['user'])['userType'] == 'candidate') {
        if ((a.data['user'])['email'] == _email) {
          isFound = true;

          break;
        }
      }
    }

    if (isFound) {
      bool foundPassword = false;
      querySnapshot =
          await Firestore.instance.collection("CandidatesKey").getDocuments();
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        var a = querySnapshot.documents[i];
        InvitationKeys invitationKey = InvitationKeys.fromJson(a.data);
        if (invitationKey.email == _email && invitationKey.key == _password) {
          foundPassword = true;
          if (invitationKey.finished == false) {
            
            // go to welcome screen
            final prefs = await SharedPreferences.getInstance();
            final key = 'userType';
            final value = 'candidate';
            prefs.setString(key, value);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeCandidateScreen(
                  email: _email,
                  invitationKey: invitationKey,
                ),
              ),
            );
            candidateEmail.clear();
            candidatePassword.clear();
            break;
          } else {
            // show msg with This test is not availabe yet
            showInSnackBar(
                "This Test was finished, see your result in your e-mail");
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowTestResult(
                  email: _email,
                  testID: invitationKey.testID,
                ),
              ),
            );*/
            //break;
          }
        } 
      }

      if(foundPassword == false){
        showInSnackBar(
                "Uncorrect password!, please check your mail again, or contact with your coach");
      }

      /*final key2 = 'userEmail';
      final value2 = _email;
      prefs.setString(key2, value2);
      print('value is $value2');*/

    } else {
      showInSnackBar("Uncorrect Email, try again, or contact with your coach");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
