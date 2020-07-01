import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/calculateResult.dart';
import 'package:tesapp/pages/candidate/candidateCompleteInfo.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/candidate/testResult.dart';
import 'package:tesapp/pages/candidate/welcomeScreen.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'package:tesapp/services/auth_service.dart';
import 'package:tesapp/views/sign_up_view.dart';
import 'francaisCandidateTest.dart';

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
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                              //border: Border.all(width: 2.5, color: Colors.black),
                              //borderRadius: BorderRadius.circular(24.0),
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/logos/sign_in.png',
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Text(
                        "ادخل بريدك الالكتروني:",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                      TextFormField(
                        controller: candidateEmail,
                        validator: EmailValidator.validate,
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          contentPadding: const EdgeInsets.only(
                              right: 14.0, bottom: 15.0, top: 15.0),
                        ),
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      Text(
                        "ادخل رقمك السري:",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                      TextFormField(
                        controller: candidatePassword,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          contentPadding: const EdgeInsets.only(
                              right: 14.0, bottom: 15.0, top: 15.0),
                        ),
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Color(0xFF3445FA),
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "تسجيل دخول",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      onPressed: submit,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Color(0xFF3445FA),
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "إنشاء حساب جديد",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                //SignUpView(authFormType: AuthFormType.signUp),
                                CandidateCompleteInfo(),
                          ),
                        );
                      },
                    ),
                  ),
                  /*FlatButton(
                    child: Text(
                      "Aren't candidate?, be coach and click now",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signIn');
                    },
                  ),*/
                ],
              ),
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
                "هذا الاختبار لقد انهيته بالفعل من فضلك راجع مسؤولك");

            // add comment from here
            /*QuerySnapshot result = await Firestore.instance.collection("CandidatesAnswers").getDocuments();
            
            /*QuerySnapshot result = await Firestore.instance
                .collection("CandidatesAnswers")
                .where('email', isGreaterThanOrEqualTo: _email)
                .getDocuments();*/

            for (int i = 0; i < result.documents.length; i++) {
              var a = result.documents[i];
              CandidateTestAnswer candidateTestAnswer =
                  CandidateTestAnswer.fromJson(a.data);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalculateResult(
                    candidateTestAnswer: candidateTestAnswer,
                    invitationKey: invitationKey,
                  ),
                ),
              );
            }*/
            // to here

            //bouabssa.loubna@gmail.com
            //BqX8cw==
            //samirhassan452@gmail.com
            //LFv59g==

            /**/

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

      if (foundPassword == false) {
        showInSnackBar(
            "هذا الباسورد الذي ادخلته خطأ من فضلك تأكد من ايميلك مرة اخرى او تواصل مع مسؤولك");
      }

      /*final key2 = 'userEmail';
      final value2 = _email;
      prefs.setString(key2, value2);
      print('value is $value2');*/

    } else {
      showInSnackBar(
          "هذا الايميل الذى ادخلته خطأ من فضلك حاول مرة اخرى او تواصل مع مسؤولك");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: new Text(value))));
  }
}
