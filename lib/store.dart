import 'package:flutter/material.dart';
import 'package:project/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';

class Store extends StatefulWidget {
  final Widget listview;
  final double total;

  Store({required this.listview, required this.total});

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _adressController = TextEditingController();
  TextEditingController _promoCode = TextEditingController();
  Users users = Users();

  @override
  void initState() {
    super.initState();

    if (users != null) {
      _nameController.text =
          '${users.getFirstName()} ${users.getMiddleName()} ${users.getLastName()}';
      _adressController.text = '${users.getAddress()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center widget added here
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align content vertically centered
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align content horizontally centered
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _adressController,
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Checkout(
                      name: _nameController.text,
                      address: _adressController.text,
                      listView: widget.listview,
                      total: widget.total,
                      change: null,
                      moneytendered: null,
                    ),
                  ),
                );
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
