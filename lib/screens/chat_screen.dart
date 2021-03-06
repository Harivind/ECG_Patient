import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient/constants.dart';
import 'package:patient/models/data.dart';
import 'package:patient/widgets/message_bubble.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;
int length;

class ChatScreen extends StatefulWidget {
  static String id = "chatScreen";
  final String doctorID;
  const ChatScreen({@required this.doctorID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
            "Dr. ${Provider.of<Data>(context).currentPatient['doctorID'][widget.doctorID]}"),
      ),
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/images/chat1.svg',
              semanticsLabel: 'Acme Logo',
              height: 200,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(
                doctorID: widget.doctorID,
                patientID:
                    Provider.of<Data>(context).currentPatient['patientID'],
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageTextController.clear();

                        _firestore
                            .collection(
                                '/messages/${widget.doctorID}/${Provider.of<Data>(context, listen: false).currentPatient['patientID']}')
                            .add(
                          {
                            'index': length,
                            'text': messageText,
                            'sender': Provider.of<Data>(context, listen: false)
                                .currentUser
                                .displayName,
                            'time': DateTime.now().toString()
                          },
                        );
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String patientID;
  final String doctorID;

  const MessagesStream({@required this.patientID, @required this.doctorID});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              semanticsLabel: "Loading Messages",
            ),
          );
        }
        final messages = snapshot.data.documents;
        messages.sort((a, b) => b.data['index'] - a.data['index']);
        length = messages.length;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageTime = message.data['time'];

          final currenUser = Provider.of<Data>(context).currentUser.displayName;

          final messageBubble = MessageBubble(
            time: messageTime,
            text: messageText,
            isMe: currenUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: messageBubbles,
          ),
        );
      },
      stream:
          _firestore.collection("/messages/$doctorID/$patientID").snapshots(),
    );
  }
}
