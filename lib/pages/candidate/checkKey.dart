import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/candidate/arabeCandidateTest.dart';
import 'package:tesapp/pages/candidate/francaisCandidateTest.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'package:tesapp/widgets/clicky_button.dart';

class CheckCandidateKey extends StatefulWidget {
  final String testCandidateKey;
  final String email;
  CheckCandidateKey({this.testCandidateKey, this.email});
  @override
  _CheckCandidateKeyState createState() => _CheckCandidateKeyState();
}

class _CheckCandidateKeyState extends State<CheckCandidateKey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Key"),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("CandidatesKey").getDocuments(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  Widget msgWidget;
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    var a = snapshot.data.documents[i];
                    InvitationKeys invitationKey =
                        InvitationKeys.fromJson(a.data);
                    if (invitationKey.email == widget.email &&
                        invitationKey.key == widget.testCandidateKey) {
                      if (invitationKey.finished == false) {
                        msgWidget = Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // hiya wli lt7t bach ndir les buttons dyali flwst
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.29,
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
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 22),
                                    ),
                                  ),
                                  onPressed: () {
                                    //send testID, and language = 'ar'
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MakeArabeCandidateTestApp(
                                          isFirstTime: true,
                                          invitationKey: invitationKey,
                                          email: widget.email,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
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
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 22),
                                    ),
                                  ),
                                  onPressed: () {
                                    //send testID, and language = 'fr'
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MakeFrancaisCandidateTest(
                                          isFirstTime: true,
                                          invitationKey: invitationKey,
                                          email: widget.email,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            //bach ndir espace binathome
                          ],
                        );
                      } else {
                        msgWidget = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("You passed this Test, see your Result Now"),
                            SizedBox(height: 16), //bach ndir espace binathome
                            ClickyButton(
                              child: Text(
                                'See Result',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                //send testID, and language = 'ar' & 'fr' and key and email to see result
                              },
                            ),
                          ],
                        );
                      }

                      break;
                    } else {
                      msgWidget =
                          Text("Key is wrong, please chech your email again");
                    }
                    //return Center(child: Text(widget.testCandidateKey),);
                  }
                  return Center(
                    child: msgWidget,
                  );
                }
            }
          }),
    );
  }
}
