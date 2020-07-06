import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataFirebase {
  void sendData(String collectionType, dynamic data) async {
    await Firestore.instance.collection(collectionType).add(data);
  }

  Future checkCandidateEmail(String collectionType, String email) async {
    bool founded = false;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection(collectionType).getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if ((a.data['user'])['userType'] == 'candidate') {
        if ((a.data['user'])['email'] == email) {
          founded = true;
          break;
        }
      }
    }

    if (founded)
      return email;
    else
      return 'un-founded';
  }
}

class InsertCandidates extends StatefulWidget {
  final FirebaseUser user;
  InsertCandidates({this.user});
  @override
  _InsertCandidatesState createState() => _InsertCandidatesState();
}

class _InsertCandidatesState extends State<InsertCandidates> {
  int number = 0;
  TextEditingController _controller = TextEditingController();
  List<TextEditingController> _candidatesController = new List();
  DataFirebase dataFirebase = new DataFirebase();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showSaveBtn = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0513AD),
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('entrer le nombre de candidates emails')),
        bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                  Icons.border_color,
                  color: Colors.white,
                )),
                controller: _controller,
                onSubmitted: (value) {
                  setState(() {
                    number = int.parse(value);
                    _showSaveBtn = true;
                  });
                },
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 100.0)),
      ),
      body: Form(
        key: formKey,
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              _candidatesController.add(new TextEditingController());
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "it is empty";
                    } else if (!value.contains('@')) {
                      return "Bad email format";
                    } else if (value.contains('@')) {
                      if (!value.contains('.'))
                        return "Bad email format";
                      else
                        return null;
                    } else if (value.contains('.')) {
                      if (!value.contains('@'))
                        return "Bad email format";
                      else
                        return null;
                    } else {
                      return null;
                    }
                  },
                  controller: _candidatesController[index],
                  cursorColor: Color(0xFF3445FA),
                  decoration: InputDecoration(
                    hintText: "Enter Email #" + (index + 1).toString(),
                    icon: Icon(
                      Icons.mode_edit,
                      color: Color(0xFF0513AD),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), //bach ndiro dak chkl dyal textfield
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              );
            },
            itemCount: number,
          ),
        ),
      ),
      floatingActionButton: Opacity(
        opacity: _showSaveBtn ? 1.0 : 0.0,
        child: new FloatingActionButton(
          onPressed: () async {
            int isFounded = 0;
            if (formKey.currentState.validate()) {
              //showAlertDialog();
              for (int i = 0; i < number; i++) {
                String foundedEmail = await dataFirebase.checkCandidateEmail(
                    'Users', _candidatesController[i].text);

                if (foundedEmail == 'un-founded') {
                } else {
                  isFounded++;
                  showInSnackBar('this email $foundedEmail is exists');
                }
              }
              if (isFounded == 0) {
                for (int i = 0; i < number; i++) {
                  _controller.clear();
                  CandidateEmailFormat candidateEmailFormat =
                      new CandidateEmailFormat(
                          adminEmail: widget.user.email,
                          email: _candidatesController[i].text);

                  dataFirebase.sendData("Users", candidateEmailFormat.toJson());
                  _candidatesController[i].clear();
                }

                Navigator.pop(context);
              }
            }
          },
          child: new Icon(Icons.check),
          backgroundColor: Color(0xFF0513AD),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: const Duration(milliseconds: 500),
    ));
  }

  showAlertDialog() {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: scaffoldKey.currentState.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CandidateEmailFormat {
  final String adminEmail;
  final String email;
  final String userType;
  CandidateEmailFormat(
      {this.adminEmail, this.email, this.userType = 'candidate'});

  Map<String, Object> toJson() {
    return {
      "addedBy": adminEmail,
      "user": {
        "email": email != null ? email : 'unknwon',
        "userType": userType,
      }
    };
  }
}
