import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsFrancais.dart';
import 'package:tesapp/pages/candidate/francaisCandidateTest.dart';
import 'package:tesapp/pages/invitation_test.dart';

class CalculateResult extends StatelessWidget {
  DataFirebase dataFirebase = new DataFirebase();
  final String email;
  final String testID;
  final InvitationKeys invitationKey;
  final CandidateTestAnswer candidateTestAnswer;
  CalculateResult(
      {this.candidateTestAnswer, this.email, this.testID, this.invitationKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[500],
    );
  }
}
