import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/les_candidates.dart';

class CandidateInvitation extends StatefulWidget {
  @override
  _CandidateInvitationState createState() => _CandidateInvitationState();
}

class _CandidateInvitationState extends State<CandidateInvitation> {
  //List<String> _emails;

  List<String> _emails;
  List<bool> _isChecked ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emails = new List<String>();
    _isChecked = new List<bool>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Candidates"),
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection('Users').getDocuments(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshotFuture) {
              switch (snapshotFuture.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshotFuture.hasError)
                    return Center(
                      child: Text("Error : ${snapshotFuture.error}"),
                    );
                  else {
                    var a = snapshotFuture.data.documents;
                    for (int i = 0; i < a.length; i++) {
                      if ((a[i].data['user'])['userType'].toString() ==
                          'candidate') {
                        _emails.add((a[i].data['user'])['email'].toString());
                        _isChecked.add(false);
                      }
                    }
                    if (_emails.length != 0) {
                      print(_emails.length);
                      return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: _emails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        _emails[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                      );
                    } else {
                      return Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("There is no Candidates for now, "),
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
                      ));
                    }
                  }
              }
            }));
  }
}
