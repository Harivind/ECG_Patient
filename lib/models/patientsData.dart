import 'package:flutter/foundation.dart';
import 'patient.dart';
import 'dart:collection';

class Patients extends ChangeNotifier {
  List<Patient> _patients = [];

  int get patientCount {
    return _patients.length;
  }

  UnmodifiableListView<Patient> get patients {
    return UnmodifiableListView(_patients);
  }

  void getPatients(String docID) {}

  // void addTask(String newTaskTitle) {
  //   _patients.add(Patient(name: newTaskTitle));
  //   notifyListeners();
  // }

  // void updateTask(Patient task) {
  //   task.toggleDone();
  //   notifyListeners();
  // }

  // void deleteTask(Task task) {
  //   _tasks.remove(task);
  //   notifyListeners();
  // }
}
