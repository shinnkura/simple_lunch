import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_lunch/screens/home.dart';

import '../constants.dart';

class EditOrderPage extends StatefulWidget {
  final String name;
  final String initialCoffeeType;
  final String initialTime;

  const EditOrderPage({
    Key? key, // 追加: keyの型を指定する必要があります
    required this.name,
    required this.initialCoffeeType,
    required this.initialTime,
  });

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  late TextEditingController _nameController;
  late TextEditingController _commentController;
  late String dropdownValue;
  late String selectedTime;
  bool isOrderCancelled = false;
  bool small = false;

  Future<void> updateOrder() async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot querySnapshot = await orders.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['name'] == widget.name &&
          data['coffeeType'] == widget.initialCoffeeType &&
          data['time'] == widget.initialTime) {
        doc.reference.update({
          'name': _nameController.text,
          'coffeeType': dropdownValue,
          'time': selectedTime,
          'small': small,
          'comment': _commentController.text, // コメントを更新
        });
        break;
      }
    }
  }

  Future<void> cancelOrder() async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot querySnapshot = await orders.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['name'] == widget.name &&
          data['coffeeType'] == widget.initialCoffeeType &&
          data['time'] == widget.initialTime) {
        doc.reference.delete();
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _commentController = TextEditingController(); // コントローラーを初期化
    dropdownValue = widget.initialCoffeeType;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('注文変更'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '名前',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _commentController, // コメント入力フィールド
                decoration: InputDecoration(
                  labelText: 'コメント',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: selectedTime,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue!;
                  });
                },
                items: <String>[
                  "12時30分",
                  "13時00分",
                  "13時30分",
                  "14時00分",
                  "14時30分",
                  "15時00分",
                  "15時30分"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!isOrderCancelled) {
                    await updateOrder();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    kPrimaryColor,
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                  ),
                ),
                child: const Text(
                  '注文',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await cancelOrder();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red,
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                  ),
                ),
                child: const Text(
                  '注文取り消し',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
