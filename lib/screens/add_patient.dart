import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient/models/data.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;
final TextEditingController patientIDTextcontroller = TextEditingController();

class AddPatient extends StatelessWidget {
  static String id = "addPatientScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("requests")
                        .where(
                          'doctorID',
                          isEqualTo:
                              (Provider.of<Data>(context).loggedIntUser.uid),
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Loading Notes",
                          ),
                        );
                      }
                      List<ListTile> patientsList = [];
                      final patients = snapshot.data.documents;
                      int length = patients.length;
                      for (var patient in patients) {
                        final _patient = ListTile(
                          title:
                              Text('Patient ID: ${patient.data['patientID']}'),
                          subtitle: Text(patient.data['granted']
                              ? "Access Granted!"
                              : "Waiting Response"),
                          trailing: Icon(
                            Icons.check_circle,
                            color: patient.data['granted']
                                ? Colors.green
                                : Colors.grey,
                          ),
                          leading: Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.black,
                          ),
                          onTap: () {},
                        );
                        patientsList.add(_patient);
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.indigo,
                              child: Text(
                                'Requested Patients',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return patientsList[index - 1];
                        },
                        itemCount: length + 1,
                      );
                    },
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey[300],
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: patientIDTextcontroller,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter Patient ID',
                      ),
                    ),
                  ),
                  SheetButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SheetButton extends StatefulWidget {
  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingPatient = false;
  bool success = false;
  bool error = true;
  @override
  Widget build(BuildContext context) {
    return !checkingPatient
        ? MaterialButton(
            color: Colors.indigo,
            onPressed: () async {
              String patID = patientIDTextcontroller.text;
              patientIDTextcontroller.clear();
              setState(() {
                checkingPatient = true;
              });
              final QuerySnapshot result = await _firestore
                  .collection('patients')
                  .where('patientID', isEqualTo: patID)
                  .getDocuments();
              bool alreadyRequested;
              await _firestore
                  .collection('requests')
                  .where(
                    'patientID',
                    isEqualTo: patID,
                  )
                  .where('doctorID',
                      isEqualTo: Provider.of<Data>(context, listen: false)
                          .loggedIntUser
                          .uid)
                  .getDocuments()
                  .then((value) {
                if (value.documents.isEmpty) {
                  alreadyRequested = false;
                } else {
                  print(value.documents);
                  alreadyRequested = true;
                }
              });

              if (result.documents.length == 0) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Patient ID does not belong to any patient'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Close",
                      onPressed: () {},
                    ),
                    elevation: 5.0,
                  ),
                );
              } else if (alreadyRequested) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Access already requested'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: "Close",
                      onPressed: () {},
                    ),
                    elevation: 5.0,
                  ),
                );
              } else {
                await _firestore.collection('requests').add(
                  {
                    'patientID': patID,
                    'doctorID': Provider.of<Data>(context, listen: false)
                        .loggedIntUser
                        .uid,
                    'granted': false,
                  },
                );
                setState(() {
                  success = true;
                  error = false;
                });
              }
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                checkingPatient = false;
                success = false;
                error = true;
              });
            },
            child: Text(
              'Request Access',
              style: TextStyle(color: Colors.white),
            ),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                error == false ? Icons.check : Icons.highlight_off,
                color: error == false ? Colors.green : Colors.red,
                size: 40,
              );
  }
}
