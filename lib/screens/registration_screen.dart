import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:patient/accountServices.dart';
import 'package:patient/widgets/rounded_buttons.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registerScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  String email;
  String password;
  String name;
  String doctorID;
  File image;
  bool showSpinner = false;
  int _source;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Future getImage(int source) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.values[source],
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
      maxWidth: 300.0,
      maxHeight: 300.0,
    );

    setState(() {
      image = File(pickedFile.path);
    });
  }

  void getSource() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'SELECT SOURCE',
            textAlign: TextAlign.center,
          ),
          content: Row(
            children: [
              FlatButton(
                onPressed: () {
                  _source = 0;
                  Navigator.pop(context);
                  getImage(_source);
                },
                child: Row(
                  children: [
                    Text("Camera  "),
                    Icon(
                      Icons.camera_alt,
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  _source = 1;
                  Navigator.pop(context);
                  getImage(_source);
                },
                child: Row(
                  children: [
                    Text("Gallery  "),
                    Icon(Icons.photo),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

  String validator(value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 150,
            ),
            child: Form(
              key: _formKey,
              autovalidate: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        image = null;
                      });
                    },
                    onTap: getSource,
                    child: CircleAvatar(
                      maxRadius: 80.0,
                      minRadius: 1.0,
                      backgroundColor:
                          image == null ? Colors.grey[200] : Colors.white,
                      child: image != null
                          ? Image.file(image, fit: BoxFit.contain)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.account_box,
                                  size: 40.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Choose a \nprofile picture",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: validator,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Full Name",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: validator,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      doctorID = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Doctor ID",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.local_hospital),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: (email) {
                      final RegExp emailRegex = new RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                      if (!emailRegex.hasMatch(email)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Email",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Icon(Icons.email),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: (pass) {
                      if (pass.length < 6) {
                        return "Password must be atleast 6 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Password",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.indigoAccent,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        showMessage('Please fill all fields!');
                      } else {
                        setState(() {
                          showSpinner = true;
                        });
                        String resp = await AccountService().register(
                          email: email,
                          password: password,
                          context: context,
                          doctorID: doctorID,
                          name: name,
                          image: image ?? null,
                        );
                        resp != null ? showMessage(resp) : resp = "";
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
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
