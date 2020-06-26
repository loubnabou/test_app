import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/candidateContinueInfo.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';

import 'package:tesapp/pages/home.dart';

import 'package:tesapp/views/sign_up_view.dart';
import 'package:tesapp/views/first_view.dart';
import 'package:tesapp/widgets/provider_widget.dart';
import 'package:tesapp/services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: "test profiling",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
          '/anonymousSignIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.anonymous),
          '/convertUser': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.convert),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  /*String userType;
  Future<void> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'userID';

    this.userType = prefs.getString(key) ?? null;
    //print(userType);
  }*/

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshotFuture) {
          switch (snapshotFuture.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshotFuture.hasError)
                return Text("Error : ${snapshotFuture.error}");
              else {
                String userType =
                    snapshotFuture.data.getString('userType') ?? null;
                if (userType == 'candidate') {
                  /*String candidateEmail =
                      snapshotFuture.data.getString('userEmail') ?? null;
                  if (candidateEmail != null)
                    return CandidateHome(
                      user: candidateEmail,
                    );
                  else*/
                    return CandidateContinueInfo();
                } else if (userType == 'coach') {
                  return StreamBuilder<FirebaseUser>(
                    stream: auth.onAuthStateChanged,
                    builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final bool signedIn = snapshot.hasData;
                        Widget widget;
                        if (signedIn) {
                          widget = Home(
                            result: snapshot.data,
                          );
                        } else {
                          widget = SignUpView(authFormType: AuthFormType.signIn);
                        }

                        return widget;
                        //return signedIn ? widget : FirstView();
                      }
                      return CircularProgressIndicator();
                    },
                  );
                } else {
                  return CandidateContinueInfo();
                }
              }
          }
        });
  }
}

/*
StreamBuilder<FirebaseUser>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        _read();
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          Widget widget;
          if (signedIn) {
            if (this.userType == 'coach')
              widget = Home(
                result: snapshot.data,
              );
            else
              widget = CandidateHome(
                user: snapshot.data,
              );
          } else{
            widget = FirstView();
          }

          return widget;
          //return signedIn ? widget : FirstView();
        }
        return CircularProgressIndicator();
      },
    )*/
