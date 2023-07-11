import 'package:flutter/material.dart';
import 'package:simple_lunch/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_order.dart';
import 'order.dart';
import '../services/order_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'しんぷるランチ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPage(
                    key: Key('order'),
                    title: '注文',
                  ),
                ),
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: Text(
              '注文する',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<
                Map<String, Map<String, List<Map<String, dynamic>>>>>(
              future: loadOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
                } else {
                  Map<String, Map<String, List<Map<String, dynamic>>>> orders =
                      snapshot.data!;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      String time = orders.keys.elementAt(index);
                      int totalOrdersAtThisTime = orders[time]!
                          .values
                          .fold(0, (prev, curr) => prev + curr.length);
                      return ExpansionTile(
                        title: Text(
                          '$time     $totalOrdersAtThisTime名',
                          style:
                              TextStyle(color: Colors.brown[800], fontSize: 20),
                        ),
                        children: orders[time]!.entries.map((entry) {
                          String coffeeType = entry.key;
                          List<Map<String, dynamic>> ordersList = entry.value;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$coffeeType     ${ordersList.length}名',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.brown[800]),
                                  ),
                                  Divider(color: Colors.brown[800]),
                                  ...ordersList.map((order) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.brown[700],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditOrderPage(
                                                  name: order['name'],
                                                  initialCoffeeType: coffeeType,
                                                  initialTime: time,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${order['name']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.brown[700],
                                              ),
                                            ),
                                            Text(
                                              'コメント: ${order['comment']}',
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: FloatingActionButton(
              onPressed: () async {
                const url =
                    'http://docs.google.com/forms/d/e/1FAIpQLSc1fO0xXfhBt_h-m62Evx0wL_J_z60Xe4rfH-zvxDGnaw-9aQ/viewform';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              backgroundColor: Colors.orange[500],
              heroTag: null,
              child: Icon(Icons.mail),
            ),
          ),
        ],
      ),
    );
  }
}
