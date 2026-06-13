import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 50});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: height,
      errorBuilder: (_, _, _) => Text(
        'K24Klik',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: kK24Green,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
