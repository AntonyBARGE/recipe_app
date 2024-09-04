import 'package:flutter/material.dart';

class GroceriesPage extends StatelessWidget {
  const GroceriesPage({super.key});

  static const routeName = '/groceries';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          color: Colors.red,
        ),
      ),
    );
  }
}
