import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Data extends ChangeNotifier {
  FirebaseUser currentUser;
  List patients = [];

  int get patientCount {
    return patients.length;
  }

  // UnmodifiableListView<dynamic> get patients {
  //   return UnmodifiableListView(patients);
  // }

  void setPatients(patients) {
    print(patients);
    this.patients = patients;
  }

  Future<void> getPatients() async {
    await Firestore.instance
        .collection('patients')
        .where('doctorID', arrayContains: currentUser.uid)
        .getDocuments()
        .then((value) => patients = value.documents);
    notifyListeners();
  }

  void addCurrentUser(FirebaseUser user) {
    currentUser = user;
    notifyListeners();
  }

  FirebaseUser get loggedIntUser {
    return currentUser;
  }
}
