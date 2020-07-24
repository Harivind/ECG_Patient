import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:patient/constants.dart';
import 'package:patient/models/data.dart';
import 'package:patient/screens/add_patient.dart';
import 'package:patient/screens/patient_screen.dart';
import 'package:patient/widgets/custom_bottom_navigation.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;

class HomeScreen extends StatelessWidget {
  static String id = "homeScreen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[200],
          onPressed: () {
            Navigator.pushNamed(context, AddPatient.id);
          },
          child: Icon(
            Icons.person_add,
            color: Colors.black,
          ),
          tooltip: "Add a Patient",
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: Colors.indigo,
                      ),
                    ],
                    gradient: purpleGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Welcome\nDr. ${Provider.of<Data>(context).loggedIntUser.displayName}',
                            style: greetingTitleStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'See How your patients are doing!',
                        style: greetingSubtitleStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          Provider.of<Data>(context, listen: false)
                              .loggedIntUser
                              .photoUrl,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Patients',
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    Provider.of<Data>(context, listen: false).getPatients();
                  },
                )
              ],
            ),
            Provider.of<Data>(context).patientCount == 0
                ? Text('Please Add Patients')
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("patients")
                        .where(
                          'doctorID',
                          arrayContains:
                              (Provider.of<Data>(context).loggedIntUser.uid),
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Loading Patients",
                          ),
                        );
                      }

                      Provider.of<Data>(context)
                          .setPatients(snapshot.data.documents);

                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Provider.of<Data>(context).patients[index]
                                            ['status'] !=
                                        'Normal'
                                    ? LinearProgressIndicator(
                                        minHeight: 98,
                                        backgroundColor: Colors.white,
                                      )
                                    : Container(),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  elevation: 2.5,
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    leading: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        child: Text(
                                          Provider.of<Data>(context)
                                              .patients[index]['name'][0],
                                        ),
                                      ),
                                      imageUrl: Provider.of<Data>(context)
                                          .patients[index]['photoURL'],
                                    ),
                                    title: Text(
                                      Provider.of<Data>(context).patients[index]
                                          ['name'],
                                    ),
                                    subtitle: Text(
                                        "ID: ${Provider.of<Data>(context).patients[index]['patientID']}"),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return PatientScreen(index: index);
                                        },
                                      ));
                                    },
                                    trailing: Icon(
                                      Icons.add_alert,
                                      color: Provider.of<Data>(context)
                                                  .patients[index]['status'] ==
                                              'Normal'
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: Provider.of<Data>(context).patientCount,
                        ),
                      );
                    },
                  ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
