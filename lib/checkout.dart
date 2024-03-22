import 'package:flutter/material.dart';
import 'package:project/dashboard.dart';
import 'package:project/profile_page.dart';

class Checkout extends StatefulWidget {
  final String name;
  final String address;
  final int contactNumber;
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
    required this.contactNumber,
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
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Address: ${widget.address}",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Contact Number: ${widget.contactNumber}",
              style: TextStyle(fontSize: 15),
            ),
            widget.listView,
            Text(
              "Total: ${widget.total}",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Money Tendered: " + _paymentController.text,
            ),
            changeLabel == ""
                ? const Text("")
                : Text(
                    changeLabel,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  showReceiptDialog(
                      widget.name, widget.address, widget.listView);
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

  void showReceiptDialog(String name, String address, Widget listView) {
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
                    "Name: $name",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Location: $address",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 500,
                    child: Expanded(
                      child: listView,
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
                        listView: listView,
                      ),
                    ),
                  ); // Close the dialog
                },
                child: Text("OK"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                child: Text('Go to Dashboard'),
              ),
            ],
          ),
        );
      },
    );
  }
}
