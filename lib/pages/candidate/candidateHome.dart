import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/checkKey.dart';
import 'package:tesapp/services/auth_service.dart';
import 'package:tesapp/views/first_view.dart';

class CandidateHome extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController keyController = new TextEditingController();
  final authHandler = new AuthService();
  final String user;
  CandidateHome({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
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
                      user,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              )),
            ),
            /*Menu(Icons.save_alt, 'Importer', () => {}),
            Menu(Icons.launch, 'Exporter', () => {}),*/
            Menu(Icons.assignment_turned_in, 'Tests',
                () => _showDialog(context)),
            Menu(Icons.assignment, 'Resultats', () => {}),
            Menu(Icons.build, 'Generer', () => {}),
            Menu(Icons.exit_to_app, 'Log-Out', () async {
              final prefs = await SharedPreferences.getInstance();
              final key2 = 'userEmail';
              final value2 = null;
              prefs.setString(key2, value2);
            }),
          ],
        ),
      ),
    );
  }

  _showDialog(context) async {
    await showDialog(
      context: context,
      child: _SystemPadding(
        child: Form(
          key: _formKey,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: keyController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "it is empty";
                      } else {
                        return null;
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Password Key', hintText: 'eJkN=='),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              /*FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),*/
              FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckCandidateKey(
                            email: user,
                            testCandidateKey: keyController.text,
                          ),
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class Menu extends StatelessWidget {
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
              this.onTap();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstView(),
                ),
              );
            } else if (this.text == 'Tests') {
              this.onTap();
              
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
