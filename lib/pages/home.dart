import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context)
        .size; // pour eviter wahd l'erreur dyla mediaquery
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Test Profiling'),
          backgroundColor: Color(0xFF5500b3),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Color(0xFF5500b3),
                  Color(0xFF8c3ce3),
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
              Menu(Icons.people, 'Les Candidates', () => InsertCandidates()),
              Menu(
                  Icons.person_add, 'Invitation', () => Candidate2Invitation()),
              //Menu(Icons.build, 'Generer', () => {}),
              Menu(Icons.exit_to_app, 'Log-Out', () => FirstView()),
            ],
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
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => this.onTap(),
                ),
              );
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
                      color: Color(0xFF7a34c5),
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
