import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget{
  _HomeAppState createState() {
    return new _HomeAppState();
  }
}

class _HomeAppState extends State<HomeApp>{
  int numOfQuestions = 0;
  TextEditingController _numOfQuestionsController = new TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children:<Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _numOfQuestionsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  isDense: true,
                  hintStyle: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: MediaQuery.of(context).size.width / 40),
                  hintText: "Enter Number of Questions?",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),

            ),
            RaisedButton(
                child: Text("Add Questions"),
                onPressed: (){
                  setState((){
                    numOfQuestions = int.parse(_numOfQuestionsController.text);
                  });
                }
            ),
            ListView.builder(
                shrinkWrap:true,
                itemCount : numOfQuestions,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        isDense: true,
                        hintStyle: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: MediaQuery.of(context).size.width / 25),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}


