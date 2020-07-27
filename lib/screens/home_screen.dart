import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient/constants.dart';
import 'package:patient/models/data.dart';
import 'package:patient/screens/chat_screen.dart';
import 'package:patient/screens/grant_access.dart';
import 'package:patient/screens/visualize_screen.dart';
import 'package:patient/widgets/custom_bottom_navigation.dart';
import 'package:patient/widgets/resuable_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String id = "homeScreen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
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
                        'Welcome\n${Provider.of<Data>(context).loggedInUser.displayName}',
                        style: greetingTitleStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            'ECG Connection: Online',
                            style: TextStyle(fontSize: 20),
                          ),
                          Switch(
                            value: true,
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
                                    .loggedInUser
                                    .photoUrl !=
                                null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  Provider.of<Data>(context, listen: false)
                                      .loggedInUser
                                      .photoUrl,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .loggedInUser
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
              flex: 2,
              child: ReusableCard(
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SvgPicture.asset(
                          'assets/images/visualise_data.svg',
                          semanticsLabel: 'Acme Logo',
                          // height: 150,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Visualize Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VisualizeScreen();
                      },
                    ),
                  );
                },
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
                        Navigator.pushNamed(context, AddDoctor.id);
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
                            semanticLabel: "Emergency",
                          ),
                          Text(
                            'Emergency',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onPress: () {
                        // FlutterBeep.playSysSound(
                        //     AndroidSoundIDs.TONE_SUP_ERROR);
                        Provider.of<Data>(context, listen: false)
                            .emergencyProtocol();
                      },
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
