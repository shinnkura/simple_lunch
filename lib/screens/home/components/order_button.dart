import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../order_screen/order_screen.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          FirebaseAnalytics.instance.logEvent(
            name: 'ボタンがおされました',
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderPage(
                title: 'Coffee Order',
                key: Key('order'),
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.brown,
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
        ),
        child: const Text(
          '注文を始める',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
