import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigoAccent, width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigoAccent, width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const purpleGradient = LinearGradient(
  colors: <Color>[
    Color(0xFF303F9F),
    Color(0xFF3F51B5),
    Color(0xFFC5CAE9),
  ],
  stops: [0.0, 0.25, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const greetingTitleStyle = TextStyle(
  fontSize: 36,
  fontWeight: FontWeight.w400,
  color: Colors.black,
  shadows: [
    Shadow(
      blurRadius: 2,
      color: Colors.black26,
    )
  ],
);

const greetingSubtitleStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  shadows: [
    Shadow(
      blurRadius: 2,
      color: Colors.indigo,
    )
  ],
);

const kSendButtonTextStyle = TextStyle(
  color: Color(0xFF3F51B5),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
      color: Color(0xFF3F51B5),
      width: 2.0,
    ),
  ),
);
