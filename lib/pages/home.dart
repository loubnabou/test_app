import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/invitation_candidates.dart';
import 'package:tesapp/pages/invitation_candidates2.dart';
import 'package:tesapp/pages/les_candidates.dart';
import 'package:tesapp/pages/sendmail.dart';
import 'package:tesapp/views/first_view.dart';

import '../services/auth_service.dart';
import 'circular_image.dart';
import 'import.dart';

class Home extends StatelessWidget {
  final FirebaseUser result;
  Home({this.result});
  @override
  Widget build(BuildContext context) {
    //FirebaseUser result = ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyWidget(user: result),
    );
  }
}

class MyWidget extends StatelessWidget {
  final FirebaseUser user;
  MyWidget({this.user});
  
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context)
        .size; // pour eviter wahd l'erreur dyla mediaquery
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: new Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            backgroundColor: Color(0xFF0513AD),
          ),
          body: FutureBuilder(
              future: Firestore.instance.collection("Coachs").getDocuments(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else {
                      Widget msgWidget;
                      List<Test> tests = new List<Test>();
                      snapshot.data.documents.forEach((element) {
                        Test tempTest = Test.fromJson(element.data);
                        if (tempTest.coachName == user.email) {
                          tests.add(tempTest);
                        }
                      });
                      print(size);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                            itemCount: tests.length == null ? 0 : tests.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orientation == Orientation.portrait)
                                            ? 2
                                            : 3),
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color(0xFF3445FA),
                                elevation: 25.0,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.fill,
                                        child: Text(
                                          tests[index].title.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                      SizedBox(
                                        height: tests[index].language == 'fr'
                                            ? 15.0
                                            : 3.0,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fill,
                                        child: Text(
                                          tests[index].subject.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: tests[index].language == 'fr'
                                            ? 15.0
                                            : 6.0,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fill,
                                        child: Text(
                                          (tests[index].language == 'fr'
                                                  ? 'Questions #: '
                                                  : 'عدد الاسئلة: ') +
                                              tests[index]
                                                  .numOfQuestions
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                }
              }),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                    Color(0xFF0513AD),
                    Color(0xFF3445FA),
                  ])),
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50.0)), //bach mayb9ach chkl mrb3
                        child: Padding(
                          padding: EdgeInsets.all(
                              8.0), // padding bach it9ad lina padding dyal image
                          child: CircleAvatar(
                            child: Image.asset(
                              'assets/images/user-logo.png',
                              width: 80,
                              height: 80,
                            ),
                          ), //ndir tswira dyl logo image: AssetImage("Assets/images/logo-RAHMA.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            8.0), // padding bach it9ad lina padding dyal image
                        child: Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                Menu(Icons.save_alt, 'Importer', () => Importer(user: user)),
                //Menu(Icons.launch, 'Exporter', () => {}),
                //Menu(Icons.assignment_turned_in, 'Tests', () => {}),
                //Menu(Icons.assignment, 'Resultats', () => {}),
                Menu(Icons.people, 'Les Candidates', () => InsertCandidates(
                  user: user,
                )),
                Menu(Icons.person_add, 'Invitation',
                    () => Candidate2Invitation()),
                //Menu(Icons.build, 'Generer', () => {}),
                Menu(Icons.exit_to_app, 'Log-Out', () => {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final authHandler = new AuthService();
  IconData icon;
  String text;
  Function onTap;
  Menu(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.deepOrange,
          onTap: () {
            if (this.text == 'Log-Out') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FirstView()),
                  (Route<dynamic> route) => false);
              authHandler.signOut();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => this.onTap(),
                ),
              );
            }
          },
          child: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Color(0xFF0513AD),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style:
                            TextStyle(fontFamily: 'RobotoMono', fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
