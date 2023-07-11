import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOrder(
  String time,
  String coffeeType,
  String name,
  String comment, // 新しいパラメータ
  // bool small,
) async {
  final prefs = await SharedPreferences.getInstance();
  // 保存するデータを作成します
  Map<String, dynamic> order = {
    'time': time,
    'coffeeType': coffeeType,
    'name': name,
    'comment': comment, // コメントを保存
    // 'small': small,
  };
  // データをJSON形式の文字列に変換します
  String orderString = jsonEncode(order);
  // データを保存します
  prefs.setString('order', orderString);
}

// Future<void> saveMenu(String title, String description) async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString('menuTitle', title);
//   prefs.setString('menuDescription', description);
// }

// Future<Map<String, String>> loadMenu() async {
//   final prefs = await SharedPreferences.getInstance();
//   String title = prefs.getString('menuTitle') ?? '今日の献立';
//   String description = prefs.getString('menuDescription') ?? '説明';
//   return {'title': title, 'description': description};
// }
