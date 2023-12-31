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
  final _commentController = TextEditingController();

  // String dropdownValue = 'コーヒー';
  String timeDropdownValue = '13時00分';
  bool small = false;

  Future<void> _saveOrder(
    String time,
    // String coffeeType,
    String name,
    // bool small,
    String comment,
  ) async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return orders
        .add({
          'time': time,
          // 'coffeeType': coffeeType,
          'name': name,
          // 'small': small,
          'comment': comment,
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kTextColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
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
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                // maxLines: 2,
                controller: _commentController,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: const InputDecoration(
                  labelText: 'コメント',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: timeDropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      timeDropdownValue = newValue!;
                    });
                  },
                  underline: Container(
                    height: 2,
                    color: kTextColor,
                  ),
                  icon: Icon(Icons.arrow_downward, color: kTextColor),
                  items: <String>[
                    "13時00分",
                    "13時30分",
                    "14時00分",
                    "14時30分",
                    "15時00分"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveOrder(
                    timeDropdownValue,
                    // dropdownValue,
                    _nameController.text,
                    // small,
                    _commentController.text,
                  );
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const HomePage(),
                      transitionDuration:
                          Duration(milliseconds: 500), // 遷移時間を0.5秒に変更
                      transitionsBuilder:
                          (context, animation, animationTime, child) {
                        animation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastOutSlowIn, // アニメーションのカーブを変更
                        );
                        return SlideTransition(
                          position: Tween(
                                  begin: Offset(-1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                }
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
                  color: kTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
