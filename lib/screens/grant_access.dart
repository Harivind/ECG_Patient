import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient/models/data.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;
final TextEditingController patientIDTextcontroller = TextEditingController();

class AddDoctor extends StatelessWidget {
  static String id = "grantAccessScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grant Access'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.indigo,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pending Requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("requests")
                          .where(
                            'patientID',
                            isEqualTo: (Provider.of<Data>(context)
                                .currentPatient['patientID']),
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              semanticsLabel: "Loading doctors",
                            ),
                          );
                        }
                        List<ListTile> doctorsList = [];
                        final doctors = snapshot.data.documents;
                        int length = doctors.length;
                        for (var doctor in doctors) {
                          final _doctor = ListTile(
                            title: Text(
                                'Doctor\'s Name: ${doctor.data['doctorName']}'),
                            subtitle:
                                Text('Doctor ID: ${doctor.data['doctorID']}'),
                            trailing: ToggleButtons(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ],
                              borderWidth: 0,
                              borderColor: Colors.white,
                              isSelected: [false, false],
                              onPressed: (value) {
                                _firestore
                                    .collection('doctors')
                                    .document(doctor.data['doctorID'])
                                    .setData({
                                  'patients': {
                                    doctor.data['patientID'].toString(): true
                                  }
                                }, merge: true);
                                _firestore
                                    .collection('patients')
                                    .document(doctor.data['patientID'])
                                    .setData({
                                  'doctorID': {
                                    doctor.data['doctorID'].toString():
                                        doctor.data['doctorName']
                                  }
                                }, merge: true);
                                _firestore
                                    .collection("requests")
                                    .document(doctor.documentID)
                                    .delete();
                              },
                            ),
                            leading: Icon(
                              Icons.person,
                              size: 45,
                              color: Colors.black,
                            ),
                            onTap: null,
                          );
                          doctorsList.add(_doctor);
                        }
                        return length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  return doctorsList[index];
                                },
                                itemCount: length,
                              )
                            : Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/nopendingrequests.svg',
                                    semanticsLabel: 'Acme Logo',
                                    height: 200,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'No Pending Requests',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                ],
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
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
                          .loggedInUser
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
                        .loggedInUser
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
