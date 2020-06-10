import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'package:tesapp/pages/les_candidates.dart';

class Candidate2Invitation extends StatefulWidget {
  @override
  _Candidate2InvitationState createState() => _Candidate2InvitationState();
}

class _Candidate2InvitationState extends State<Candidate2Invitation> {
  //List<String> _emails;

  List<String> _emails;
  List<bool> _isChecked;
  bool _showSaveBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emails = new List<String>();
    _isChecked = new List<bool>();
    _loadEmails();

    /*QuerySnapshot querySnapshot =
        await Firestore.instance.collection('Users').getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if ((a.data['user'])['userType'] == 'candidate') {
        if ((a.data['user'])['email'] == email) {
          founded = true;
          break;
        }
      }
    }*/
  }

  _loadEmails() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('Users').getDocuments();

    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if ((a.data['user'])['userType'].toString() == 'candidate') {
        setState(() {
          _emails.add((a.data['user'])['email'].toString());
          _isChecked.add(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Candidates"),
      ),
      body: _emails.length != 0
          ? ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _emails.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              _emails[index],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: _isChecked[index],
                            onChanged: (bool val) {
                              setState(() {
                                _isChecked[index] = val;
                              });
                            })
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("There is no Candidates for now,"),
                FlatButton(
                  child: Text(
                    'add Candidate now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsertCandidates(),
                      ),
                    );
                  },
                ),
              ],
            )),
      floatingActionButton: Opacity(
        opacity: _checkIfChooseEmail() ? 1.0 : 0.0,
        child: FloatingActionButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              List<String> _emailsList = new List<String>();
              for (int i = 0; i < _isChecked.length; i++) {
                if (_isChecked[i]) {
                  _emailsList.add(_emails[i]);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestInvitation(emailsList: _emailsList,),
                ),
              );
            }),
      ),
    );
  }

  _checkIfChooseEmail() {
    bool founded = false;
    for (int i = 0; i < _isChecked.length; i++) {
      if (_isChecked[i] == true) {
        founded = true;
      }
    }

    return founded;
  }
}
