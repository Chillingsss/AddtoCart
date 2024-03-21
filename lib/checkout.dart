import 'package:flutter/material.dart';
import 'package:project/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  final String name;
  final String address;
  final Widget listView;
  final double total;
  final double? moneytendered;
  final double? change;

  Checkout({
    required this.name,
    required this.address,
    required this.listView,
    required this.total,
    required this.moneytendered,
    required this.change,
  });

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double change = 0;
  String changeLabel = "";
  final TextEditingController _paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
              "Money Tendered: " + _paymentController.text,
            ),
            changeLabel == ""
                ? const Text("")
                : Text(
                    changeLabel,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              width: 500,
              child: TextFormField(
                controller: _paymentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Payment",
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                if (int.parse(_paymentController.text) >= widget.total) {
                  setState(() {
                    change = int.parse(_paymentController.text) - widget.total;
                    changeLabel = "Change: ${change.toString()}";
                  });
                  showReceiptDialog(); // Show the receipt dialog
                } else {
                  setState(() {
                    changeLabel = "Payment is not enough";
                  });
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void showReceiptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 500,
          height: 500,
          child: AlertDialog(
            title: Text("Receipt"),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CHECKOUT",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Name: ${widget.name}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Location: ${widget.address}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 500,
                    child: Expanded(
                      child: widget.listView,
                    ),
                  ),
                  Text(
                    "Total: ${widget.total}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Money Tendered: " + _paymentController.text,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  if (changeLabel != "")
                    Text(
                      changeLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        listView: widget.listView,
                      ),
                    ),
                  ); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }
}
