import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_lunch/constants.dart';
import 'package:simple_lunch/screens/edit_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/menu_service.dart';
import 'edit_order.dart';
import 'order.dart';
import '../services/order_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String menuTitle = '今日の献立';
  String menuDescription = '説明';
  Map<String, bool> checkboxStates = {};

  @override
  void initState() {
    super.initState();
    loadMenu().then((menu) {
      setState(() {
        menuTitle = menu['title'];
        menuDescription = menu['description'];
      });
    });
  }

  void updateMenu(String title, String description) {
    setState(() {
      menuTitle = title;
      menuDescription = description;
    });
    saveMenu(title, description);
  }

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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditMenuScreen(
                    updateMenu: updateMenu,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: double.infinity,
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    menuDescription,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
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
          const SizedBox(height: 50),
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
                      return ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            checkboxStates[time] = !isExpanded;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    checkboxStates[time] = !isExpanded;
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                    '$time     $totalOrdersAtThisTime名',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                            body: Column(
                              children: orders[time]!.entries.map((entry) {
                                List<Map<String, dynamic>> ordersList =
                                    entry.value;
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...ordersList.map((order) {
                                        return Dismissible(
                                          key: Key(order['name']),
                                          onDismissed: (direction) async {
                                            // スワイプされたときに該当のorderを削除します。
                                            CollectionReference orders =
                                                FirebaseFirestore.instance
                                                    .collection('orders');
                                            QuerySnapshot querySnapshot =
                                                await orders.get();
                                            for (var doc
                                                in querySnapshot.docs) {
                                              Map<String, dynamic> data =
                                                  doc.data()
                                                      as Map<String, dynamic>;
                                              if (data['name'] ==
                                                      order['name'] &&
                                                  data['time'] == time) {
                                                doc.reference.delete();
                                                break;
                                              }
                                            }
                                          },
                                          background:
                                              Container(color: Colors.red),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          checkboxStates[order[
                                                                  'name']] =
                                                              !checkboxStates[
                                                                  order[
                                                                      'name']]!;
                                                        });
                                                      },
                                                      child: Checkbox(
                                                        value: checkboxStates[
                                                                order[
                                                                    'name']] ??
                                                            false,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            checkboxStates[order[
                                                                    'name']] =
                                                                value!;
                                                          });
                                                        },
                                                        activeColor:
                                                            Colors.orange,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${order['name']}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: checkboxStates[
                                                                      order[
                                                                          'name']] ??
                                                                  false
                                                              ? Colors.grey
                                                              : kTextColor,
                                                          decoration: checkboxStates[
                                                                      order[
                                                                          'name']] ??
                                                                  false
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: kTextColor,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditOrderPage(
                                                              name:
                                                                  order['name'],
                                                              initialTime: time,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50.0),
                                                  child: Text(
                                                    '${order['comment']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            isExpanded: checkboxStates[time] ?? false,
                          ),
                        ],
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
              child: Icon(Icons.receipt_long),
            ),
          ),
        ],
      ),
    );
  }
}
