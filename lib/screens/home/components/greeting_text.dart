import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lottie.asset('assets/coffee.json'),
        Text(
          'お疲れ様です！',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
