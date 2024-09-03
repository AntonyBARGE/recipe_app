import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Looking for your favorite meal",
                  style: theme.headlineMedium,
                ),
                const Spacer(),
                Image.asset(
                  "images/foods/profile-picture.webp",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
