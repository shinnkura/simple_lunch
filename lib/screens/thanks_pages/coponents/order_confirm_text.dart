import 'package:flutter/material.dart';

class OrderConfirmationText extends StatelessWidget {
  const OrderConfirmationText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'ご注文を承りました',
      style: TextStyle(fontSize: 20, color: Colors.brown[700]),
    );
  }
}