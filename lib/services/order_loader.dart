import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, Map<String, List<Map<String, dynamic>>>>> loadOrder() async {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  Map<String, Map<String, List<Map<String, dynamic>>>> ordersMap =
      SplayTreeMap();

  QuerySnapshot querySnapshot = await orders.get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String time = data['time'];
    String coffeeType = data['coffeeType'];
    String name = data['name'];
    String? comment = data['comment']; // Null許容型を使用
    // bool small = data['small'] ?? false;
    if (ordersMap[time] == null) {
      ordersMap[time] = {};
    }
    if (ordersMap[time]![coffeeType] == null) {
      ordersMap[time]![coffeeType] = [];
    }
    ordersMap[time]![coffeeType]!.add({
      'name': name,
      'comment': comment ?? '', // Nullチェックを行い、Nullの場合は空文字列を割り当てる
      // 'small': small,
    });
  }

  return ordersMap;
}
