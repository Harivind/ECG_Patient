import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:patient/accountServices.dart';
import 'package:patient/screens/home_screen.dart';
import 'package:patient/widgets/rounded_buttons.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = "loginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool showSpinner = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        elevation: 15.0,
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your Email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log in',
                colour: Colors.indigoAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  String resp = await AccountService().login(
                    email: email,
                    pass: password,
                    context: context,
                  );
                  resp != null ? showMessage(resp) : resp = "";
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
              FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signInAnonymously();
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.id, (route) => false);
                },
                child: Text('anonymous'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
