import 'package:cloud_firestore/cloud_firestore.dart';

class MenuService {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu');

  Future<void> updateMenu(String title, String description) {
    return _menuCollection.doc('current').set({
      'title': title,
      'description': description,
    });
  }

  Stream<DocumentSnapshot> getMenu() {
    return _menuCollection.doc('current').snapshots();
  }
}
