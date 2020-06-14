import 'package:flutter/material.dart';
import 'package:tesapp/pages/candidate/arabeCandidateTest.dart';
import 'package:tesapp/pages/candidate/francaisCandidateTest.dart';
import 'package:tesapp/pages/invitation_test.dart';

class ChooseTestLanguage extends StatelessWidget {
  final String email;
  final InvitationKeys invitationKey;
  ChooseTestLanguage({this.email, this.invitationKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Language"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // hiya wli lt7t bach ndir les buttons dyali flwst
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.29,
                  child: Image.asset(
                    'assets/images/moroccoFlag.png',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Arabe'.toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                  onPressed: () {
                    //send testID, and language = 'ar'
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeArabeCandidateTestApp(
                          isFirstTime: true,
                          invitationKey: invitationKey,
                          email: email,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 70),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Image.asset(
                    'assets/images/franceFlag.jpg',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Francais'.toUpperCase(),
                      style: TextStyle(color: Colors.grey[500], fontSize: 22),
                    ),
                  ),
                  onPressed: () {
                    //send testID, and language = 'fr'
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeFrancaisCandidateTest(
                          isFirstTime: true,
                          invitationKey: invitationKey,
                          email: email,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            //bach ndir espace binathome
          ],
        ),
      ),
    );
  }
}
