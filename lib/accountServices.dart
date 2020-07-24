import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:patient/models/data.dart';
import 'package:patient/screens/home_screen.dart';
import 'package:provider/provider.dart';

class AccountService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> login({
    @required String email,
    @required String pass,
    @required BuildContext context,
  }) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (user != null) {
        Provider.of<Data>(context, listen: false).addCurrentUser(user.user);
        Provider.of<Data>(context, listen: false).getPatients();
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> register(
      {@required String email,
      @required String password,
      @required String name,
      @required String doctorID,
      File image,
      @required BuildContext context}) async {
    String imageURL = '';

    try {
      final QuerySnapshot result = await Firestore.instance
          .collection('doctors')
          .where('doctorID', isEqualTo: doctorID)
          .getDocuments();

      final List<DocumentSnapshot> documents = result.documents;
      print("length" + documents.length.toString());
      if (documents.length > 0) {
        throw "Doctor ID Already Exists";
      }

      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (newUser != null) {
        if (image != null) {
          StorageReference storageReference = FirebaseStorage.instance
              .ref()
              .child('doctor/${Path.basename(image.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(image);
          await uploadTask.onComplete;
          print('File Uploaded');
          imageURL = await storageReference.getDownloadURL();
        }
        Firestore.instance
            .collection('doctors')
            .document(newUser.user.uid)
            .setData({
          'doctorID': doctorID,
          'name': name,
          'photoUrl': imageURL,
          'email': email,
          'patients': [],
          'uid': newUser.user.uid
        });
        var userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.photoUrl = imageURL;
        userUpdateInfo.displayName = name;
        await newUser.user.updateProfile(userUpdateInfo);
        Provider.of<Data>(context, listen: false).addCurrentUser(newUser.user);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );
      }
    } catch (e) {
      return e.toString();
    }
  }
}
