import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import '../thanks_pages/thanks_page.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_dropdown_button.dart';
import 'components/custom_elevated_button.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String dropdownValue = 'コーヒー';
  String timeDropdownValue = '15時30分';
  bool small = false;
  bool _isSugar = false;
  bool caramel = false;
  bool _isCondecensedMilk = false;
  bool _isPickupOn4thFloor = false;

  Future<void> _saveOrder(
    String time,
    String coffeeType,
    String name,
    bool small,
    bool isSugar,
    bool caramel,
    bool isCondecensedMilk,
    bool isPickupOn4thFloor,
  ) async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return orders
        .add({
          'time': time,
          'coffeeType': coffeeType,
          'name': name,
          'small': small,
          'isSugar': isSugar,
          'caramel': caramel,
          'isCondecensedMilk': isCondecensedMilk,
          'isPickupOn4thFloor': isPickupOn4thFloor,
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0 * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: const InputDecoration(
                  labelText: '名前',
                  labelStyle: TextStyle(color: kTextColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTextColor),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'お名前をご記入ください';
                  }
                  return null;
                },
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton<String>(
                value: timeDropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    timeDropdownValue = newValue!;
                  });
                },
                items: const ['15時30分', '17時30分'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: const [
                  'コーヒー',
                  'カフェオレ',
                  'ちょいふわカフェオレ',
                  'ふわふわカフェオレ',
                  'アイスコーヒー（水出し）',
                  'アイスコーヒー(急冷式)',
                  'アイスカフェオレ',
                  'アイスカフェオレ（ミルク多め）',
                  'ソイラテ',
                  'アイスソイラテ',
                  '温かい緑茶',
                  '冷たい緑茶',
                ],
              ),
            ),
            CheckboxListTile(
              title: const Text("少なめ（250ml程度）"),
              value: small,
              onChanged: (bool? value) {
                setState(() {
                  small = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("砂糖あり"),
              value: _isSugar,
              onChanged: (bool? value) {
                setState(() {
                  _isSugar = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("キャラメルシロップ"),
              value: caramel,
              onChanged: (bool? value) {
                setState(() {
                  caramel = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("練乳あり"),
              value: _isCondecensedMilk,
              onChanged: (bool? value) {
                setState(() {
                  _isCondecensedMilk = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("４階で受け取る"),
              value: _isPickupOn4thFloor,
              onChanged: (bool? value) {
                setState(() {
                  _isPickupOn4thFloor = value!;
                });
              },
            ),
            CustomElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveOrder(
                    timeDropdownValue,
                    dropdownValue,
                    _nameController.text,
                    small,
                    _isSugar,
                    caramel,
                    _isCondecensedMilk,
                    _isPickupOn4thFloor,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ThanksPage()),
                  );
                }
              },
              text: '注文',
            ),
          ],
        ),
      ),
    );
  }
}
