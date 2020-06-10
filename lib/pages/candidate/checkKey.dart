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
                            ClickyButton(
                              child: Text(
                                'un Test',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                //send testID, and language = 'fr'
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MakeFrancaisCandidateTest(
                                          isFirstTime: true,
                                          invitationKey: invitationKey,
                                        ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16), //bach ndir espace binathome

                            ClickyButton(
                              child: Text(
                                'الاختبار',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              color: Colors.green,
                              onPressed: () {
                                //send testID, and language = 'ar'
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MakeArabeCandidateTestApp(
                                          isFirstTime: true,
                                          invitationKey: invitationKey,
                                        ),
                                  ),
                                );
                              },
                            ),
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
