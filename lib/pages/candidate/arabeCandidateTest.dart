import 'package:flutter/material.dart';
import 'package:tesapp/pages/invitation_test.dart';


class MakeArabeCandidateTestApp extends StatelessWidget {
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  MakeArabeCandidateTestApp({this.isFirstTime = true, this.invitationKey});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (BuildContext context) {
              return ArabeCandidateTest(
                isFirstTime: isFirstTime,
                invitationKey: invitationKey,
              );
            },
          ),
        );
      },
    );
  }
}

class ArabeCandidateTest extends StatefulWidget {
  final bool isFirstTime;
  final InvitationKeys invitationKey;
  ArabeCandidateTest({this.isFirstTime = true, this.invitationKey});
  @override
  _ArabeCandidateTestState createState() => _ArabeCandidateTestState();
}

class _ArabeCandidateTestState extends State<ArabeCandidateTest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}