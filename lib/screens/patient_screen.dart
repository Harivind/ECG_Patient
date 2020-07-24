import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient/models/data.dart';
import 'package:patient/screens/chat_screen.dart';
import 'package:patient/screens/notes_screen.dart';
import 'package:patient/widgets/resuable_card.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatelessWidget {
  static String id = "patientScreen";
  final int index;

  const PatientScreen({@required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.accessibility),
            Text('  Patient'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 18),
                    child: ReusableCard(
                      onPress: null,
                      cardChild: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Icon(
                                  Icons.account_circle,
                                  size: 120,
                                ),
                                imageUrl: Provider.of<Data>(context)
                                    .patients[index]['photoURL'],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '${Provider.of<Data>(context).patients[index]['name']}',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              Text(
                                'Patient ID: ${Provider.of<Data>(context).patients[index]['patientID']}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Provider.of<Data>(context).patients[index]['status'] !=
                              'Normal'
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.white,
                              minHeight: 100,
                            )
                          : Container(),
                      ReusableCard(
                        cardChild: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ${Provider.of<Data>(context).patients[index]['status']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(
                                Icons.add_alert,
                                color: Provider.of<Data>(context)
                                            .patients[index]['status'] ==
                                        'Normal'
                                    ? Colors.grey
                                    : Colors.red,
                              )
                            ],
                          ),
                        ),
                        onPress: null,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            onPress: () {},
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/ecg.svg',
                                  semanticsLabel: 'Acme Logo',
                                  height: 75,
                                ),
                                Text(
                                  'View ECG Data',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            onPress: () {},
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assessment,
                                  color: Colors.green,
                                  size: 75,
                                ),
                                Text(
                                  'View Summary',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              showModalBottomSheet<dynamic>(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => NotesScreen(
                                  patientID: Provider.of<Data>(context)
                                      .patients[index]['patientID'],
                                ),
                              );
                            },
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment,
                                  size: 75,
                                  color: Colors.yellow,
                                  semanticLabel: "Notes",
                                ),
                                Text(
                                  'View Notes',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatScreen(
                                      patientIndex: index,
                                    );
                                  },
                                ),
                              );
                            },
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Colors.indigo,
                                  size: 75,
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
