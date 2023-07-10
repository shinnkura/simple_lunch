import 'package:flutter/material.dart';

import '../../order_lists/order_list.dart';

class OrderListButton extends StatelessWidget {
  const OrderListButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.brown[800],
        minimumSize: const Size(200, 60), // ボタンの最小サイズを設定
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderListPage()),
        );
      },
      child: const Text(
        '注文一覧へ',
        style: TextStyle(fontSize: 20), // テキストのサイズを大きく
      ),
    );
  }
}
