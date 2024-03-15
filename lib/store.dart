import 'package:project/checkout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  final Widget listview;
  final double total;
  Store({required this.listview, required this.total});

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _promoCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _name,
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
              controller: _address,
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
              controller: _promoCode,
              decoration: InputDecoration(
                labelText: "Promo Code",
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
                      name: _name.text,
                      address: _address.text,
                      promoCode: _promoCode.text,
                      listView: widget.listview!,
                      total: widget.total,
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
