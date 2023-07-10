import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../thanks_pages/thanks_page.dart';
import 'components/coffee_type_dropdown.dart';

class EditOrderPage extends StatefulWidget {
  final String name;
  final String initialCoffeeType;
  final String initialTime;

  const EditOrderPage({
    super.key,
    required this.name,
    required this.initialCoffeeType,
    required this.initialTime,
  });

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  late TextEditingController _nameController;
  late String dropdownValue;
  late String selectedTime;
  bool isOrderCancelled = false;
  bool small = false;
  bool isSugar = false;
  bool caramel = false;
  bool isCondecensedMilk = false;
  bool isPickupOn4thFloor = false;

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
          'isSugar': isSugar,
          'caramel': caramel,
          'isCondecensedMilk': isCondecensedMilk,
          'isPickupOn4thFloor': isPickupOn4thFloor,
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
            const SizedBox(height: 20),
            if (!isOrderCancelled) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CoffeeTypeDropdown(
                  dropdownValue: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedTime,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTime = newValue!;
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
              const SizedBox(height: 20),
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
                title: const Text("砂糖"),
                value: isSugar,
                onChanged: (bool? value) {
                  setState(() {
                    isSugar = value!;
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
                title: const Text("練乳"),
                value: isCondecensedMilk,
                onChanged: (bool? value) {
                  setState(() {
                    isCondecensedMilk = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("４階で受け取る"),
                value: isPickupOn4thFloor,
                onChanged: (bool? value) {
                  setState(() {
                    isPickupOn4thFloor = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!isOrderCancelled) {
                    await updateOrder();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ThanksPage()),
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
                    MaterialPageRoute(builder: (context) => const ThanksPage()),
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
