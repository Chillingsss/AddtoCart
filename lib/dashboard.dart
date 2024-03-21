import 'package:flutter/widgets.dart';
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
  String canton = "Canton";
  String argentina = "Argentina";
  String century = "Century";
  String sanmarino = "San Marino";
  String cornedbeef = "Corned Beef";

  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        iconTheme: IconThemeData(
            color: Colors.white), // Set the color of icons to white
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("SHOPPING CART"),
                    content: Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: 500,
                            width: 500,
                            child: createListView(),
                          ),
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
        child: Container(
          color: Color.fromARGB(255, 155, 155, 155),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "PITOK",
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
                                'images/tawas.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/tawas.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Text("Tawas"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 28.0),
                          child: Text("₱10.00"),
                        ),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: Text("Noodles"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Text("₱30.00"),
                        ),
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
                                'images/rexona.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/rexona.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("Rexona"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("₱20.00"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            saveRecord(
                              shampoo,
                              10,
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
                        Text("₱10.00"),
                      ],
                    ),
                  ),
                ],
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
                              canton,
                              14,
                              Image.asset(
                                'images/chilli.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/chilli.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text("Pancit Canton"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 28.0),
                          child: Text("₱14.00"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            saveRecord(
                              canton,
                              14,
                              Image.asset(
                                'images/extra.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/extra.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text("Pancit Canton"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Text("₱14.00"),
                        ),
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
                              canton,
                              14,
                              Image.asset(
                                'images/sweet.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/sweet.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("Pancit Canton"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("14.00"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            saveRecord(
                              shampoo,
                              10,
                              Image.asset(
                                'images/original.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/original.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text("Pancit Canton"),
                        Text("₱14.00"),
                      ],
                    ),
                  ),
                ],
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
                              sanmarino,
                              29,
                              Image.asset(
                                'images/sanmarino.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/sanmarino.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text("San Marino"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 28.0),
                          child: Text("₱29.00"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            saveRecord(
                              century,
                              34.50,
                              Image.asset(
                                'images/century.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/century.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text("Century Tuna"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Text("₱34.50"),
                        ),
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
                              argentina,
                              20,
                              Image.asset(
                                'images/argentina.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/argentina.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("Argentina"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text("₱20.00"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            saveRecord(
                              cornedbeef,
                              39.75,
                              Image.asset(
                                'images/cornedbeef.png',
                                height: 100,
                                width: 100,
                              ),
                            );
                          },
                          child: Image.asset(
                            'images/cornedbeef.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text("Corned Beef"),
                        Text("₱39.75"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
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
