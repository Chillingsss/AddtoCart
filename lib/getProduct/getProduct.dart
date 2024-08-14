import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String name;
  final String barcode;
  final double price;
  final int stocks;
  final String category;

  Product({
    required this.name,
    required this.barcode,
    required this.price,
    required this.stocks,
    required this.category,
  });
}

class GetProduct extends StatefulWidget {
  @override
  _GetProductState createState() => _GetProductState();
}

class _GetProductState extends State<GetProduct> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/products.php'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'operation': 'getAllProduct',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _products = data.map<Product>((item) {
            return Product(
              name: item['prod_name'].toString(),
              barcode: item['prod_id'].toString(),
              price: double.parse(item['prod_price'].toString()),
              stocks: int.parse(item['prod_stocks'].toString()),
              category: item['prod_category'].toString(),
            );
          }).toList();
        });
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1.5), // Barcode
                  1: FlexColumnWidth(3), // Product Name
                  2: FlexColumnWidth(2), // Price
                  3: FlexColumnWidth(2), // Stocks
                  4: FlexColumnWidth(2.5), // Category
                },
                border: TableBorder.symmetric(
                  inside: BorderSide(color: Colors.black),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.white),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Barcode',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Product',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Price',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Stocks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Category',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                  // Map through the products to create table rows
                  ..._products.map((product) {
                    return TableRow(
                      decoration: BoxDecoration(color: Colors.white),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text(product.barcode,
                              style: TextStyle(color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text(product.name,
                              style: TextStyle(color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text('${product.price.toStringAsFixed(2)} Php',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text('${product.stocks} Stocks',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text(product.category,
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
