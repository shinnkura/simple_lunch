import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOrder(
  String time,
  String coffeeType,
  String name,
  // bool small,
) async {
  final prefs = await SharedPreferences.getInstance();
  // 保存するデータを作成します
  Map<String, dynamic> order = {
    'time': time,
    'coffeeType': coffeeType,
    'name': name,
    // 'small': small,
  };
  // データをJSON形式の文字列に変換します
  String orderString = jsonEncode(order);
  // データを保存します
  prefs.setString('order', orderString);
}
