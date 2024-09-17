import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        SizedBox(
          height: 20,
        ),
        Text('Chargement en cours...'),
      ],
    );
  }
}
