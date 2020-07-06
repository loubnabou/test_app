import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesapp/pages/formsArabe.dart';
import 'package:tesapp/widgets/clicky_button.dart';

import 'formsFrancais.dart';
import 'importFrancais.dart';

class Importer extends StatelessWidget {
  final FirebaseUser user;
  Importer({this.user});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFe9e5e6),
          appBar: new AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: Color(0xFF0513AD),
            title: new Text('Importer un test '),
          ),
          body: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // hiya wli lt7t bach ndir les buttons dyali flwst
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClickyButton(
                  child: Text(
                    'importer un test en Francais!',
                    style: TextStyle(color: Colors.white, fontSize: 22,),
                  ),
                  color: Color(0xFF0513AD),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsertFrancais(
                          user: user,
                          isFirstTime: true,
                          testKey: '',
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16), //bach ndir espace binathome

                ClickyButton(
                  child: Text(
                    'تحميل اختبار بالعربية',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  color: Color(0xFF0513AD),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyArabeTestApp(
                          user: user,
                          isFirstTime: true,
                          testKey: '',
                        )
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
