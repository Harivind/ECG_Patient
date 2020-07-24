import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget cardChild;
  final Function onPress;

  ReusableCard({
    @required this.cardChild,
    @required this.onPress,
    this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        child: cardChild,
        onTap: onPress,
      ),
    );
  }
}
