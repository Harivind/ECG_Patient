import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient/models/data.dart';
import 'package:patient/widgets/ecg_graph.dart';
import 'package:patient/widgets/resuable_card.dart';
import 'package:provider/provider.dart';

class VisualizeScreen extends StatefulWidget {
  @override
  _VisualizeScreenState createState() => _VisualizeScreenState();
}

class _VisualizeScreenState extends State<VisualizeScreen> {
  Timer t;
  bool receivingNormal = true;

  @override
  void initState() {
    // TODO: implement initState
    t = Timer.periodic(Duration(seconds: 1), (x) {
      Provider.of<Data>(context, listen: false).addNormalPoint();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Live ECG Data',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            EcgGraph(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "REPORT",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            Provider.of<Data>(context).anomalyDetected !=
                                    'Normal'
                                ? 'Status: Anomaly detected'
                                : 'Status: Normal',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(
                            Provider.of<Data>(context).anomalyDetected !=
                                    'Normal'
                                ? Icons.mood_bad
                                : Icons.mood,
                            color: Provider.of<Data>(context).anomalyDetected !=
                                    'Normal'
                                ? Colors.red
                                : Colors.green,
                            size: 50,
                          )
                        ],
                      ),
                      onPress: null,
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Center(
                        child: Text(
                          'Current Prediction: \n${Provider.of<Data>(context).anomalyDetected}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      onPress: null,
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Hardware Status: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      onPress: null,
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Click to Toggle Data',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.cached,
                            size: 36,
                            color: Colors.pinkAccent,
                          ),
                        ],
                      ),
                      onPress: () {
                        print('building');
                        t.cancel();
                        if (receivingNormal) {
                          receivingNormal = false;
                          t = Timer.periodic(Duration(seconds: 1), (x) {
                            Provider.of<Data>(context, listen: false)
                                .addPVCPoint();
                          });
                        } else {
                          receivingNormal = true;
                          t = Timer.periodic(Duration(seconds: 1), (x) {
                            Provider.of<Data>(context, listen: false)
                                .addNormalPoint();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
