import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/communication-mark.svg',
            ),
          ),
        ),
      ),
    );
  }
}
