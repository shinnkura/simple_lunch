import 'package:flutter/material.dart';
import 'coponents/order_confirm_text.dart';
import 'coponents/order_list_button.dart';
import 'coponents/thank_you_text.dart';

class ThanksPage extends StatelessWidget {
  const ThanksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ThankYouText(),
            SizedBox(height: 20),
            OrderConfirmationText(),
            SizedBox(height: 40),
            OrderListButton(),
          ],
        ),
      ),
    );
  }
}
