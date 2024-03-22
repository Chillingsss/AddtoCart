import 'package:flutter/material.dart';
import 'package:project/checkout.dart';

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
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController =
      TextEditingController(); // Updated variable name
  Users users = Users();

  @override
  void initState() {
    super.initState();

    if (users != null) {
      _nameController.text =
          '${users.getFirstName()} ${users.getMiddleName()} ${users.getLastName()}';
      _addressController.text = '${users.getAddress()}';
      _contactNumberController.text = '${users.getCPNumber()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center widget added here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              controller: _addressController,
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
            TextField(
              controller: _contactNumberController, // Corrected variable name
              decoration: InputDecoration(
                labelText: "Contact Number",
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
                      address: _addressController.text,
                      contactNumber: int.parse(_contactNumberController
                          .text), // Corrected variable name
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
