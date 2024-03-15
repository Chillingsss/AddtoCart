import 'package:project/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:project/store.dart';
import 'package:project/main.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> _shopList = [];
  String coke = "Coke";
  String noodles = "Noodles";
  String bulad = "Bulad";
  String shampoo = "Shampoo";

  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("SHOPPING CART"),
                    content: Container(
                      height: 500,
                      width: 500,
                      child: createListView(),
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.shopping_cart),
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            height: 70,
            child: IconButton(
              icon: Icon(Icons.exit_to_app, size: 30),
              onPressed: () {
                _logout();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "ANDREWSABEL",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text("STORE"),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          saveRecord(
                            coke,
                            10,
                            Image.asset(
                              'images/coke.jpg',
                              height: 100,
                              width: 100,
                            ),
                          );
                        },
                        child: Image.asset(
                          'images/coke.jpg',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Text("Coke"),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          saveRecord(
                            noodles,
                            30,
                            Image.asset(
                              'images/noodles.jpg',
                              height: 100,
                              width: 100,
                            ),
                          );
                        },
                        child: Image.asset(
                          'images/noodles.jpg',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Text("Noodles"),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          saveRecord(
                            bulad,
                            20,
                            Image.asset(
                              'images/bulad.jpg',
                              height: 100,
                              width: 100,
                            ),
                          );
                        },
                        child: Image.asset(
                          'images/bulad.jpg',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Text("Bulad"),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          saveRecord(
                            shampoo,
                            40,
                            Image.asset(
                              'images/shampoo.png',
                              height: 100,
                              width: 100,
                            ),
                          );
                        },
                        child: Image.asset(
                          'images/shampoo.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Text("Shampoo"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Store(
                      listview: createListView(),
                      total: total,
                    ),
                  ),
                );
              },
              child: Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }

  void saveRecord(String order, double price, Image image) {
    Map<String, dynamic> shopCart = {
      "order": order,
      "price": price,
      "image": image,
    };

    setState(() {
      _shopList.add(shopCart);
      total += price;
    });
  }

  Widget createListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _shopList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              _shopList[index]['order'],
            ),
            subtitle: Text(_shopList[index]['price'].toString()),
            leading: _shopList[index]['image'],
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
      (route) => false,
    );
  }
}
