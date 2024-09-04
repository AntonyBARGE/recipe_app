import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealsHeader extends StatelessWidget {
  const MealsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            "Looking for your favorite meal",
            style: theme.headlineMedium,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        SizedBox(
          height: 60.w,
          width: 60.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/images/foods/profile-picture.webp",
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
