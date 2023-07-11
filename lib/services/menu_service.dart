import 'package:cloud_firestore/cloud_firestore.dart';

// Future<Map<String, dynamic>> loadMenu() async {
//   DocumentReference menuDoc =
//       FirebaseFirestore.instance.collection('menu').doc('current');
//   DocumentSnapshot snapshot = await menuDoc.get();
//   Map<String, dynamic> menuData = snapshot.data() as Map<String, dynamic>;
//   return menuData;
// }

// Future<void> updateMenu(String title, String description) async {
//   DocumentReference menuDoc =
//       FirebaseFirestore.instance.collection('menu').doc('current');
//   return await menuDoc.set({
//     'title': title,
//     'description': description,
//   });
// }

// Firebaseを使用してメニューを保存します
Future<void> saveMenu(String title, String description) async {
  DocumentReference menuDoc =
      FirebaseFirestore.instance.collection('menu').doc('current');
  return await menuDoc.set({
    'title': title,
    'description': description,
  });
}

// Firebaseからメニューを読み込みます
Future<Map<String, dynamic>> loadMenu() async {
  DocumentReference menuDoc =
      FirebaseFirestore.instance.collection('menu').doc('current');
  DocumentSnapshot snapshot = await menuDoc.get();
  Map<String, dynamic> menuData = snapshot.data() as Map<String, dynamic>;
  return menuData;
}
