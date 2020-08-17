import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/candidateContinueInfo.dart';
import 'package:tesapp/pages/candidate/welcomeScreen.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'package:tesapp/pages/les_candidates.dart';
import 'package:tesapp/services/auth_service.dart';
import 'package:tesapp/views/sign_up_view.dart';

class CandidateCompleteInfo extends StatefulWidget {
  @override
  _CandidateCompleteInfoState createState() => _CandidateCompleteInfoState();
}

class _CandidateCompleteInfoState extends State<CandidateCompleteInfo> {
  DateTime selectedDate = DateTime.now();
  bool isFirstTimeForData = true;
  bool showDateError = false;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController candidateName = new TextEditingController();
  TextEditingController candidateEmail = new TextEditingController();
  TextEditingController candidatePassword = new TextEditingController();
  TextEditingController candidatePhone = new TextEditingController();
  TextEditingController candidateBirthdate = new TextEditingController();
  TextEditingController candidateJob = new TextEditingController();
  String _name;
  String _email;
  String _password;
  String _phone;
  String _birthdate;
  String _job;
  String warning;

  DataFirebase dataFirebase = new DataFirebase();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        isFirstTimeForData = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                          height: MediaQuery.of(context).size.height * 0.06),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.41,
                          height: MediaQuery.of(context).size.height * 0.21,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/logos/sign_up.png',
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      TextFormField(
                        controller: candidateName,
                        style: TextStyle(fontSize: 22.0),
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          hintText: "الإسم الكامل",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      TextFormField(
                        controller: candidateEmail,
                        validator: EmailValidator.validate,
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          hintText: "البريد الإلكتروني",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      TextFormField(
                        controller: candidatePassword,
                        validator: PasswordValidator.validate,
                        style: TextStyle(fontSize: 22.0),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "الباسورد",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      TextFormField(
                        controller: candidatePhone,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          hintText: "الهاتف",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _phone = value;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      /*TextFormField(
                        controller: candidateBirthdate,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          hintText: "تاريخ الميلاد",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _birthdate = value;
                        },
                      ),*/
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.07,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 15.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Text(
                              isFirstTimeForData
                                  ? "تاريخ ميلادك"
                                  : "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(fontSize: 22.0),
                            )),
                      ),
                      Visibility(
                        visible: showDateError,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 5.0),
                          child: Text(
                            "لا يمكن تركه فارغاً",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      TextFormField(
                        controller: candidateJob,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
                        style: TextStyle(fontSize: 22.0),
                        decoration: InputDecoration(
                          hintText: "الوظيفة",
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
                              right: 14.0, bottom: 10.0, top: 10.0),
                        ),
                        onSaved: (value) {
                          _job = value;
                        },
                      ),
                    ],
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
                          "إنشاء الحساب",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      onPressed: submit,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  GestureDetector(
                    child: Text(
                      'هل لديك حساب بالفعل؟ إضغط الآن',
                      style: TextStyle(
                          color: Color(0xFF3445FA),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CandidateContinueInfo(),
                        ),
                      );
                    },
                  ),
                  /*GestureDetector(
                    child: Text(
                      'هل أنت مدرب؟ إضغط هنا',
                      style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignUpView(authFormType: AuthFormType.signIn),
                        ),
                      );
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
        if (checkDate()) {
          _birthdate =
              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
          _checkEmail();
        }
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
      checkDate();
      return false;
    }
  }

  bool checkDate() {
    if (isFirstTimeForData == false) {
      setState(() {
        showDateError = false;
      });

      return true;
    } else {
      setState(() {
        showDateError = true;
      });

      return false;
    }
  }

  void _checkEmail() async {
    bool isFound = false;

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Users").getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if ((a.data['user'])['email'] == _email) {
        isFound = true;

        break;
      }
    }

    if (isFound) {
      showInSnackBar("هذا الإيميل موجود بالفعل ، قم بتسجيل الدخول الآن");
    } else {
      final prefs = await SharedPreferences.getInstance();
      final key = 'userType';
      final value = 'candidate';
      prefs.setString(key, value);

      CandidateInfo candidateInfo = new CandidateInfo(
          adminEmail: 'nobody',
          email: _email,
          name: _name,
          mobile: _phone,
          job: _job,
          birthdate: _birthdate);

      InvitationKeys invitationKey = new InvitationKeys(
          invitedBy: 'nobody',
          email: _email,
          key: _password,
          testID: '1pejtA==');

      dataFirebase.sendData("Users", candidateInfo.toJson());
      dataFirebase.sendData("CandidatesKey", invitationKey.toJson());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeCandidateScreen(
            email: _email,
            invitationKey: invitationKey,
          ),
        ),
      );

      candidateName.clear();
      candidatePassword.clear();
      candidatePhone.clear();
      candidateEmail.clear();
      candidateJob.clear();
      setState(() {
        isFirstTimeForData = true;
        selectedDate = DateTime.now();
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: new Text(
              value,
              style: TextStyle(fontSize: 18.0),
            ))));
  }
}

class CandidateInfo {
  final String adminEmail;
  final String email;
  final String name;
  final String mobile;
  final String birthdate;
  final String job;
  final String userType;
  CandidateInfo(
      {this.adminEmail,
      this.email,
      this.name,
      this.mobile,
      this.birthdate,
      this.job,
      this.userType = 'candidate'});

  Map<String, Object> toJson() {
    return {
      "addedBy": adminEmail,
      "user": {
        "email": email != null ? email : 'unknwon',
        "name": name != null ? name : 'unknwon',
        "mobile": mobile != null ? mobile : 'unknwon',
        "birthdate": birthdate != null ? birthdate : 'unknwon',
        "job": job != null ? job : 'unknwon',
        "userType": userType,
      }
    };
  }
}
