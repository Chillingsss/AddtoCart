import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:project/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:project/store.dart';
import 'package:project/main.dart';
import 'package:project/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardCashier extends StatefulWidget {
  @override
  _DashboardCashierState createState() => _DashboardCashierState();
}

class _DashboardCashierState extends State<DashboardCashier> {
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Adjust to the actual LoginPage
        (route) => false,
      );
    }
  }

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

  Users users = Users();

  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FlutterLogo(
          textColor: Colors.white, // Set text color to white
          size: 30, // Set logo size
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        iconTheme: IconThemeData(
            color: Colors.white), // Set the color of icons to white
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
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
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            height: 70,
            child: IconButton(
              icon: Icon(Icons.exit_to_app, size: 30),
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            label: 'Checkout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          if (index == 2) {
            // Assuming "Profile" is at index 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Store(
                        listview: createListView(),
                        total: total,
                      )),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardCashier()),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              accountName: Text(users.getUserFullName()),
              accountEmail: Text(users.getEmail()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/${users.getImage()}"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person), // Add an icon
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
                  "Makyus",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                        Card(
                          color: Color.fromARGB(255, 69, 56, 56),
                          // Wrap the Tawas image in a Card
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
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
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/tawas.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "Tawas",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "₱10.00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Card(
                          color: Color.fromARGB(255, 69, 56, 56),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                saveRecord(
                                  noodles,
                                  10,
                                  Image.asset(
                                    'images/noodles.jpg',
                                    height: 100,
                                    width: 100,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/noodles.jpg',
                                    height: 100,
                                    width: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "Noodles",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "₱10.00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/rexona.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        "Rexona",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        "₱20.00",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  saveRecord(
                                    shampoo,
                                    100,
                                    Image.asset(
                                      'images/shampoo.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/shampoo.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        "Shampoo",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        "₱100.00",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Card(
                          color: Color.fromARGB(255, 69, 56, 56),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
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
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/chilli.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      "Pancit Canton",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      "₱14.00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                        ),
                        Card(
                          color: Color.fromARGB(255, 69, 56, 56),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
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
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/extra.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "Pancit Canton",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1.0),
                                    child: Text(
                                      "₱14.00",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 60,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/sweet.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Text("Pancit Canton",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Text("₱14.00",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  saveRecord(
                                    shampoo,
                                    100,
                                    Image.asset(
                                      'images/original.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/original.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text("Pancit Canton",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                    Text("₱14.00",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/sanmarino.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text("San Marino",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text("₱29.00",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/century.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text("Century Tuna",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text("₱34.50",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 80,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/argentina.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Text("Argentina",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Text("₱20.00",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Card(
                            color: Color.fromARGB(255, 69, 56, 56),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/cornedbeef.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text("Corned Beef",
                                        style: TextStyle(color: Colors.white)),
                                    Text("₱39.75",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                width: 50,
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
        return ListTile(
          title: Text(
            _shopList[index]['order'],
          ),
          subtitle: Text(_shopList[index]['price'].toString()),
          leading: _shopList[index]['image'],
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                total -= _shopList[index]['price']; // Update total
                _shopList.removeAt(index); // Remove item from list
              });
            },
          ),
        );
      },
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
