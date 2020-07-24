import 'package:flutter/material.dart';
import 'package:patient/widgets/custom_bottom_navigation.dart';

class AccountScreen extends StatelessWidget {
  static String id = "accountScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
