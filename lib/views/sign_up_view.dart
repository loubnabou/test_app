import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesapp/pages/candidate/candidateContinueInfo.dart';
import 'package:tesapp/pages/candidate/candidateHome.dart';
import 'package:tesapp/pages/home.dart';
import 'package:tesapp/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tesapp/views/idCoachPage.dart';
import 'package:tesapp/widgets/provider_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

// TODO move this to tone location
final primaryColor = const Color(0xFF7a34c5);

enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning, _birthday, _job;
  TextEditingController _c;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _c = new TextEditingController();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            /*final prefs = await SharedPreferences.getInstance();
            final key = 'userType';
            final userType = prefs.getString(key) ?? null;
            print(userType);
            if (userType == 'candidate') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateContinueInfo(),
                ),
              );
            }*/
            //Navigator.of(context).pushReplacementNamed('/home', arguments: result);

            FirebaseUser result =
                await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    IDOfCoach(user: result, actionType: 'sign_in'),
              ),
            );

            break;
          case AuthFormType.signUp:
            FirebaseUser result = await auth.createUserWithEmailAndPassword(
                _email, _password, _name);
            print(result);
            //Navigator.of(context).pushReplacementNamed('/home', arguments: result);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    IDOfCoach(user: result, actionType: 'sign_up'),
              ),
            );
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            setState(() {
              _warning = "A password reset link has been sent to $_email";
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            var result = await auth.singInAnonymously();
            Navigator.of(context)
                .pushReplacementNamed('/home', arguments: result);
            break;
          case AuthFormType.convert:
            await auth.convertUserWithEmail(_email, _password, _name);
            Navigator.of(context).pop();
            break;
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          backgroundColor: primaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitDoubleBounce(
                color: Colors.white,
              ),
              Text(
                "Loading",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ));
    } else {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: Color(0xFF0513AD),
              height: _height,
              width: _width,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height * 0.025),
                    showAlert(),
                    SizedBox(height: _height * 0.025),
                    buildHeaderText(),
                    //buildLogo(),
                    SizedBox(height: _height * 0.035),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: buildInputs() + buildButtons(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  Widget buildLogo() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
            //border: Border.all(width: 2.5, color: Colors.black),
            //borderRadius: BorderRadius.circular(24.0),
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/logos/sign_up.png',
                ),
                fit: BoxFit.cover)),
      ),
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // if were in the sign up state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Name"),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 20));

    /*if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Birthday"),
          onSaved: (value) => _birthday = value,
        ),
      );
      textFields.add(SizedBox(height: 20));

      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Job"),
          onSaved: (value) => _job = value,
        ),
      );
      textFields.add(SizedBox(height: 30));
    }*/
    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButtonText = "Cancel";
      _newFormState = "home";
      _submitButtonText = "Sign Up";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      FlatButton(
        child: Text(
          'You are candidate? click Now',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandidateContinueInfo(),
            ),
          );
        },
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10),
        ],
      ),
      visible: visible,
    );
  }
}
