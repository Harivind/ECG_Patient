import 'package:flutter/material.dart';
import 'package:patient/constants.dart';
import 'package:patient/models/data.dart';
import 'package:patient/screens/chat_screen.dart';
import 'package:patient/screens/grant_access.dart';
import 'package:patient/widgets/custom_bottom_navigation.dart';
import 'package:patient/widgets/ecg_graph.dart';
import 'package:patient/widgets/resuable_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String id = "homeScreen";
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('building');
            Provider.of<Data>(context, listen: false).addPoint();
          },
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
                      Text(
                        'Welcome\n${Provider.of<Data>(context).loggedIntUser.displayName}',
                        style: greetingTitleStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            'ECG Connection: Offline',
                            style: TextStyle(fontSize: 20),
                          ),
                          Switch(
                            value: false,
                            onChanged: (value) {},
                          ),
                        ],
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
                      Container(
                        height: 80,
                        child: Provider.of<Data>(context, listen: false)
                                    .loggedIntUser
                                    .photoUrl !=
                                null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  Provider.of<Data>(context, listen: false)
                                      .loggedIntUser
                                      .photoUrl,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .loggedIntUser
                                      .displayName[0]
                                      .toUpperCase(),
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              flex: 3,
              child: ReusableCard(
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: EcgGraph(gradientColors: gradientColors),
                      ),
                      Text('ECG Data',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  onPress: null),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart,
                            size: 50,
                            color: Colors.indigo,
                            semanticLabel: "Visualize",
                          ),
                          Text(
                            'Visualize \nData',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onPress: () {},
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 50,
                            color: Colors.indigo,
                            semanticLabel: "Access Request",
                          ),
                          Text(
                            'Grant Data Access',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onPress: () {
                        Navigator.pushNamed(context, AddPatient.id);
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            size: 50,
                            color: Colors.indigo,
                            semanticLabel: "Chat",
                          ),
                          Text(
                            'Chat',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onPress: () {
                        showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Container(
                            color: Color(0xFF757575),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Text(
                                        'Select Doctor',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.person,
                                          size: 45,
                                          color: Colors.black,
                                        ),
                                        title: Text(
                                          "Dr. ${Provider.of<Data>(context).currentPatient['doctorID'][Provider.of<Data>(context).currentPatient['doctorID'].keys.elementAt(index)]}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        trailing: Icon(
                                          Icons.chat,
                                          color: Color(0xFFFF4081),
                                          size: 35,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return ChatScreen(
                                                doctorID: Provider.of<Data>(
                                                        context)
                                                    .currentPatient['doctorID']
                                                    .keys
                                                    .elementAt(index),
                                              );
                                            },
                                          ));
                                        },
                                      ),
                                    ],
                                  );
                                },
                                itemCount: Provider.of<Data>(context)
                                    .currentPatient['doctorID']
                                    .keys
                                    .length,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ReusableCard(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 45,
                            color: Colors.red,
                            semanticLabel: "Notes",
                          ),
                          Text(
                            'Emergency',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onPress: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

class SelectDoctor extends StatelessWidget {
  const SelectDoctor({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
    );
  }
}
