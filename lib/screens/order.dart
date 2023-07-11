import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_lunch/screens/home.dart';
import '../constants.dart';
// import 'custom_dropdown_button.dart';

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

  Future<void> _saveOrder(
    String time,
    String coffeeType,
    String name,
    bool small,
  ) async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return orders
        .add({
          'time': time,
          'coffeeType': coffeeType,
          'name': name,
          'small': small,
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
              child: DropdownButton<String>(
                value: timeDropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    timeDropdownValue = newValue!;
                  });
                },
                items: <String>['15時30分', '17時30分']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveOrder(
                    timeDropdownValue,
                    dropdownValue,
                    _nameController.text,
                    small,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }
              },
              child: Text('注文'),
            ),
          ],
        ),
      ),
    );
  }
}
