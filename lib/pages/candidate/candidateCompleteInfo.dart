import 'package:flutter/material.dart';
import 'package:tesapp/services/auth_service.dart';
import 'package:tesapp/views/sign_up_view.dart';

class CandidateCompleteInfo extends StatefulWidget {
  @override
  _CandidateCompleteInfoState createState() => _CandidateCompleteInfoState();
}

class _CandidateCompleteInfoState extends State<CandidateCompleteInfo> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController candidateName = new TextEditingController();
  TextEditingController candidateEmail = new TextEditingController();
  TextEditingController candidatePhone = new TextEditingController();
  TextEditingController candidateBirthdate = new TextEditingController();
  TextEditingController candidateJob = new TextEditingController();
  String _name;
  String _email;
  String _phone;
  String _birthdate;
  String _job;

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
                          width: MediaQuery.of(context).size.width * 0.62,
                          height: MediaQuery.of(context).size.height * 0.32,
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
                        controller: candidatePhone,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'لا يمكن ان يكون فارغا';
                          else
                            return null;
                        },
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
                      TextFormField(
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
                          "تسجيل دخول",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'You are Coach? click Now',
                      style: TextStyle(
                          color: Color(0xFF3445FA),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignUpView(authFormType: AuthFormType.signIn),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
