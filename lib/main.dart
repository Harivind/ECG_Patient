import 'package:flutter/material.dart';
import 'package:patient/screens/account_screen.dart';
import 'package:patient/screens/add_patient.dart';
import 'package:patient/screens/home_screen.dart';
import 'package:patient/screens/login_screen.dart';
import 'package:patient/screens/registration_screen.dart';
import 'package:patient/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
