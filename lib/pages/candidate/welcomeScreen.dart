import 'package:flutter/material.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/candidate/checkKey.dart';
import 'package:tesapp/pages/chooseTestLanguage.dart';
import 'package:tesapp/pages/invitation_test.dart';

class WelcomeCandidateScreen extends StatefulWidget {
  final String email;
  final InvitationKeys invitationKey;
  WelcomeCandidateScreen({this.email, this.invitationKey});

  @override
  _WelcomeCandidateScreenState createState() => _WelcomeCandidateScreenState();
}

class _WelcomeCandidateScreenState extends State<WelcomeCandidateScreen> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController keyController = new TextEditingController();

  PageController _welcomeScreenPageController;
  int currentpage = 0;
  List<String> listOfImages = [
    'assets/images/welcomeScreens/first_screen.png',
    'assets/images/welcomeScreens/second_screen.png',
    'assets/images/welcomeScreens/third_screen.png',
    'assets/images/welcomeScreens/fourth_screen.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _welcomeScreenPageController = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 1.0,
    );
  }

  @override
  dispose() {
    _welcomeScreenPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Card(
            elevation: 20.0,
            child: Stack(children: <Widget>[
              PageView(
                controller: _welcomeScreenPageController,
                scrollDirection: Axis.horizontal,
                reverse: false,
                children: listOfImages
                    .map(
                      (image) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            //border: Border.all(width: 2.5, color: Colors.black),
                            //borderRadius: BorderRadius.circular(24.0),
                            image: DecorationImage(
                                image: AssetImage(
                                  image,
                                ),
                                fit: BoxFit.cover)),
                      ),
                    )
                    .toList(),
                onPageChanged: (pageNum) {
                  setState(() {
                    currentpage = pageNum;
                  });
                },
              ),
              currentpage != listOfImages.length - 1
                  ? Positioned(
                      bottom: 20.0,
                      left: 25.0,
                      right: 25.0,
                      child: PageIndicator(
                        numOfIndicators: listOfImages.length,
                        selectedPage: currentpage,
                        welcomeScreenPageController:
                            _welcomeScreenPageController,
                      ))
                  : Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      right: 25.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: RaisedButton(
                            elevation: 10.0,
                            //#E1EEF5
                            //#3445FA
                            //#0513AD
                            //#FF0000
                            //color: Colors.blue[500],
                            color: Color(0xFF0513AD),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text("ابدأ الاختبار الآن",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseTestLanguage(
                                    email: widget.email,
                                    invitationKey: widget.invitationKey,
                                  ),
                                ),
                              );
                            }),
                      )),
            ]),
          ),
        ),
      ),
    );
  }

  /*
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
                        labelText: 'Password Key'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckCandidateKey(
                            email: widget.user,
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
  */
}

/*
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
*/

class PageIndicator extends StatelessWidget {
  final int selectedPage;
  final int numOfIndicators;
  final PageController welcomeScreenPageController;

  PageIndicator(
      {this.numOfIndicators,
      this.selectedPage,
      this.welcomeScreenPageController});

  Widget _inactivePhoto() {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color: Colors.indigo[400],
            borderRadius: BorderRadius.circular(4.0)),
      ),
    ));
  }

  Widget _activePhoto() {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        height: 15.0,
        width: 15.0,
        decoration: BoxDecoration(
          color: Colors.indigo[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ));
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < numOfIndicators; i++) {
      if (i == selectedPage)
        indicators.add(_activePhoto());
      else
        indicators.add(GestureDetector(
            onTap: () {
              welcomeScreenPageController.animateToPage(i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            },
            child: _inactivePhoto()));
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildIndicators(),
      ),
    );
  }
}
