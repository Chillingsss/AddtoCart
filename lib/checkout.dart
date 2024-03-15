import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  final String name;
  final String address;
  final String promoCode;
  final Widget listView;
  final double total;

  Checkout(
      {required this.name,
      required this.address,
      required this.promoCode,
      required this.listView,
      required this.total});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  // String name = "";
  // String address = "";
  // String promocode = "";
  // int total = 0;

  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   final prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     name = prefs.getString("name")!;
  //     address = prefs.getString("address")!;
  //     promocode = prefs.getString("promocode")!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "CHECKOUT",
            style: TextStyle(fontSize: 50),
          ),
          Text(
            "Name: ${widget.name}",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Address: ${widget.address}",
            style: TextStyle(fontSize: 20),
          ),
          widget.listView,
          Text(
            "Total: ${widget.total}",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Promo CODE: ${widget.promoCode}",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
