import 'package:flutter/material.dart';
import 'package:tesapp/widgets/clicky_button.dart';
//
//import 'candidat.dart';
//import 'consultant.dart';
//
class premierePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,// hiya wli lt7t bach ndir les buttons dyali flwst
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//
//
          ClickyButton(
            child: Text(
              'vous etes candidat',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22),
            ),
            color: Colors.deepPurpleAccent,
            onPressed: () {/*Navigator
                .push(context, MaterialPageRoute(
              builder: (context)=>candidat(),
            ),
            );*/
            },
          ),
          SizedBox(height: 16),//bach ndir espace binathome
//
          ClickyButton(
            child: Text(
              'vous etes consultant' ,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22),
            ),
            color: Colors.deepPurpleAccent,
            onPressed: () {/*
              Navigator
                  .push(context, MaterialPageRoute(
                builder: (context)=>consultant(),
              ),
              );*/
            },
          ),
//
        ],
      ),
//
    );
  }
//
}
