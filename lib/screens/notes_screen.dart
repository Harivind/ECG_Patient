import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient/models/data.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  final String patientID;
  final _firestore = Firestore.instance;

  NotesScreen({@required this.patientID});
  @override
  Widget build(BuildContext context) {
    String newNote;
    int length;
    TextEditingController noteController = TextEditingController();
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              semanticsLabel: "Loading Notes",
            ),
          );
        }

        final notes = snapshot.data.documents;
        notes.sort((a, b) => a.data['index'] - b.data['index']);
        length = notes.length;
        List<Text> notesList = [];
        for (var note in notes) {
          final _note = Text(
            '${note.data['index'] + 1}.${note.data['note']}',
            style: TextStyle(fontSize: 18),
          );
          notesList.add(_note);
        }

        return Container(
          color: Color(0xFF757575),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NOTES  ',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color(0xFF3F51B5),
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.note_add,
                        size: 30,
                        color: Colors.pink,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: noteController,
                      cursorColor: Color(0xFF3F51B5),
                      onChanged: (value) {
                        newNote = value;
                      },
                      autofocus: false,
                    ),
                  ),
                  RaisedButton(
                    color: Colors.indigo[200],
                    onPressed: () {
                      if (newNote != null) {
                        _firestore
                            .collection(
                                '/notes/${Provider.of<Data>(context, listen: false).currentUser.uid}/$patientID')
                            .add(
                          {
                            'index': length,
                            'note': newNote,
                            'time': DateTime.now().toString(),
                          },
                        );
                        noteController.clear();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.playlist_add,
                            size: 30,
                          ),
                          Text(
                            ' Add Note ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return notesList[index];
                      },
                      itemCount: length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      stream: _firestore
          .collection(
              "/notes/${Provider.of<Data>(context).currentUser.uid}/$patientID")
          .snapshots(),
    );
  }
}
