import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class ThankYouText extends StatelessWidget {
  const ThankYouText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Lottie.asset('assets/success.json'),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'ありがとうございます!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
        ),
      ],
    );
  }
}
