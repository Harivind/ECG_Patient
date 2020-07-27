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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('building');
          t.cancel();
          t = Timer.periodic(Duration(seconds: 1), (x) {
            Provider.of<Data>(context, listen: false).addPVCPoint();
          });
        },
      ),
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
                            Provider.of<Data>(context)
                                    .last10Prediction
                                    .contains(3)
                                ? 'Status: Anomaly detected'
                                : 'Status: Normal',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(
                            Provider.of<Data>(context)
                                    .last10Prediction
                                    .contains(3)
                                ? Icons.mood_bad
                                : Icons.mood,
                            color: Provider.of<Data>(context)
                                    .last10Prediction
                                    .contains(3)
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
                      cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            Provider.of<Data>(context)
                                    .last10Prediction
                                    .contains(3)
                                ? 'Anomalies Detected: \nPremature Ventricular Contract'
                                : 'Anomalies Detected: None',
                            style: TextStyle(fontSize: 20),
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
                            'Hardware Status: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ],
                      ),
                      onPress: null,
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
