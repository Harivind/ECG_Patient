import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:patient/models/data.dart';
import 'package:patient/screens/account_screen.dart';
import 'package:patient/screens/grant_access.dart';
import 'package:patient/screens/home_screen.dart';
import 'package:patient/screens/login_screen.dart';
import 'package:patient/screens/registration_screen.dart';
import 'package:patient/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: ChangeNotifierProvider(
        create: (BuildContext context) {
          return Data();
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColorDark: Color(0xFF303F9F),
            primaryColor: Color(0xFF3F51B5),
            accentColor: Color(0xFFFF4081),
            primaryColorLight: Color(0xFFC5CAE9),
            primaryTextTheme: TextTheme(
              bodyText1: TextStyle(
                color: Colors.black,
              ),
              bodyText2: TextStyle(
                color: Color(0xFF757575),
              ),
            ),
            dividerColor: Color(0xFFBDBDBD),
            fontFamily: "Roboto",
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: "Roboto",
              ),
            ),
          ),
          home: Scaffold(
            body: WelcomeScreen(),
          ),
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            AddPatient.id: (context) => AddPatient(),
            AccountScreen.id: (context) => AccountScreen(),
          },
        ),
      ),
    );
  }
}
