// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:project/getProduct/getProduct.dart';
import 'package:project/lineChart/lineChart.dart';
import 'package:project/main.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardAdminState createState() => _DashboardAdminState();
}

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

class _DashboardAdminState extends State<DashboardAdmin> {
  List<FlSpot> _lineChartSpots = [];
  List<BarChartGroupData> _chartData = [];
  // List<Product> _products = [];
  List<String> _productNames = [];
  List<String> _monthLabels = [];
  double thisMonthSales = 0.0;
  double lastMonthSales = 0.0;

  @override
  void initState() {
    checkLoginStatus();

    super.initState();
    _fetchSalesData();
    _fetchThisMonthSales();
    _fetchLastMonthSales();
    _fetchSalesMonthData();
    // _fetchProducts();
  }

  // Future<void> _fetchProducts() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://localhost/flutter/products.php'),
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body: {
  //         'operation': 'getAllProduct',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body) as List<dynamic>;
  //       setState(() {
  //         _products = data.map<Product>((item) {
  //           return Product(
  //             name: item['prod_name'].toString(),
  //             barcode: item['prod_id'].toString(),
  //             price: double.parse(item['prod_price'].toString()),
  //             stocks: int.parse(item['prod_stocks'].toString()),
  //             category: item['prod_category'].toString(),
  //           );
  //         }).toList();
  //       });
  //     } else {
  //       print('Failed to load products');
  //     }
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //   }
  // }

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

  Future<void> _fetchSalesData() async {
    Map<String, String> body = {
      'operation': 'getBoughtProductsForThisMonth',
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/sales.php'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        print('Fetched data: $data');

        setState(() {
          _productNames =
              data.map<String>((item) => item['name'].toString()).toList();
          _chartData = data.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            double value = double.tryParse(item['sold'].toString()) ?? 0.0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: value,
                  colors: [_getColorForIndex(index)],
                  width: 18,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList();
        });
      } else {
        print('Failed to load sales data');
      }
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }

  Future<void> _fetchThisMonthSales() async {
    Map<String, String> body = {
      'operation': 'getThisMonthSales',
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/sales.php'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          thisMonthSales = double.parse(data[0]['totalAmount'] ?? '0.0');
        });
      } else {
        print('Failed to load this month sales');
      }
    } catch (e) {
      print('Error fetching this month sales: $e');
    }
  }

  Future<void> _fetchLastMonthSales() async {
    Map<String, String> body = {
      'operation': 'getLastMonthSales',
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/sales.php'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          lastMonthSales = double.parse(data[0]['totalAmount'] ?? '0.0');
        });
      } else {
        print('Failed to load last month sales');
      }
    } catch (e) {
      print('Error fetching last month sales: $e');
    }
  }

  Future<void> _fetchSalesMonthData() async {
    Map<String, String> body = {
      'operation': 'getMonthlySales', // Ensure this matches your PHP operation
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/sales.php'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        print('Fetched sales data: $data'); // Log the data

        setState(() {
          // Prepare data for the LineChart
          List<FlSpot> spots = data.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            double value =
                double.tryParse(item['totalAmount'].toString()) ?? 0.0;

            return FlSpot(index.toDouble(), value);
          }).toList();

          List<String> monthLabels = data.map<String>((item) {
            String month = item['month'].toString();
            return _getShortMonth(month); // Convert to short month name
          }).toList();

          // Update the LineChart with the new data
          _lineChartSpots = spots;
          _monthLabels = monthLabels;
        });
      } else {
        print('Failed to load sales data');
      }
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }

  String _getShortMonth(String month) {
    const Map<String, String> monthMap = {
      'January': 'Jan',
      'February': 'Feb',
      'March': 'Mar',
      'April': 'Apr',
      'May': 'May',
      'June': 'Jun',
      'July': 'Jul',
      'August': 'Aug',
      'September': 'Sep',
      'October': 'Oct',
      'November': 'Nov',
      'December': 'Dec',
    };
    return monthMap[month] ?? month;
  }

  Color _getColorForIndex(int index) {
    const List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.teal,
      Colors.indigo,
      Colors.lime,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logout();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300], // Set the background color here
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side with GetProduct
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GetProduct(),
                  ),
                ),
                const SizedBox(width: 20), // Spacer between left and right

                // Right side with Sales Info, Line Chart, and Bar Chart
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SalesInfoCard(
                        thisMonthSales: thisMonthSales,
                        lastMonthSales: lastMonthSales,
                      ),
                      const SizedBox(height: 20), // Spacer between elements

                      Container(
                        width: 500, // Adjust the width as needed
                        height: 300,
                        child: LineChartWidget(),
                      ),
                      const SizedBox(height: 20), // Spacer between elements

                      if (_chartData.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
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
                          width: 500,
                          height: 320,
                          child: Row(
                            children: [
                              Expanded(
                                child: BarChartWidget(
                                  chartData: _chartData,
                                  productNames: _productNames,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children:
                                    _productNames.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String name = entry.value;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color: _getColorForIndex(index),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        name,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesInfoCard extends StatelessWidget {
  final double thisMonthSales;
  final double lastMonthSales;

  SalesInfoCard({
    required this.thisMonthSales,
    required this.lastMonthSales,
  });

  @override
  Widget build(BuildContext context) {
    double percentageChange =
        ((thisMonthSales - lastMonthSales) / lastMonthSales) * 100;
    String percentageChangeText = (percentageChange >= 0)
        ? '+${percentageChange.toStringAsFixed(2)}%'
        : '${percentageChange.toStringAsFixed(2)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month\'s Sales: \₱${thisMonthSales.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last Month\'s Sales: \₱${lastMonthSales.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Change: $percentageChangeText',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: (percentageChange >= 0) ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> chartData;
  final List<String> productNames;

  BarChartWidget({required this.chartData, required this.productNames});

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum sold value
    double maxY = chartData.fold(0, (max, group) {
      return math.max(max, group.barRods[0].y);
    });

    maxY *= 1.2;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 500,
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: chartData,
                alignment: BarChartAlignment.spaceEvenly,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  topTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(showTitles: false),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.y.toString(),
                        const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                maxY: maxY, // Set the maximum y-axis value
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class LineChartWidget extends StatelessWidget {
//   final List<FlSpot> spots;
//   final List<String> monthLabels;

//   LineChartWidget({super.key, required this.spots, required this.monthLabels});

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         backgroundColor: Colors.white, // Background color
//         borderData: FlBorderData(
//           show: true, // Show the border
//           border: Border(
//             top: BorderSide(
//               color: Colors.red, // Top border color
//               width: 2, // Top border width
//             ),
//             bottom: BorderSide(
//               color: Colors.green, // Bottom border color
//               width: 2, // Bottom border width
//             ),
//             left: BorderSide(
//               color: Colors.blue, // Left border color
//               width: 2, // Left border width
//             ),
//             right: BorderSide(
//               color: Colors.yellow, // Right border color
//               width: 2, // Right border width
//             ),
//           ),
//         ),
//         gridData: FlGridData(
//           show: true,
//           drawHorizontalLine: true,
//           drawVerticalLine: true,
//           horizontalInterval:
//               (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1) / 5,
//           verticalInterval: 1,
//           getDrawingHorizontalLine: (value) {
//             return FlLine(
//               color: Colors.grey.shade400,
//               strokeWidth: 0.5,
//             );
//           },
//           getDrawingVerticalLine: (value) {
//             return FlLine(
//               color: Colors.grey.shade400,
//               strokeWidth: 0.5,
//             );
//           },
//         ),
//         titlesData: FlTitlesData(
//           leftTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 40,
//           ),
//           bottomTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 40,
//             getTitles: (value) {
//               int index = value.toInt();
//               if (index < monthLabels.length) {
//                 return monthLabels[index];
//               } else {
//                 return '';
//               }
//             },
//           ),
//           topTitles: SideTitles(showTitles: false),
//           rightTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval:
//                 (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1) /
//                     5,
//             getTitles: (value) {
//               if (value == 0) {
//                 return '';
//               }
//               return '${(value / 1000).toStringAsFixed(0)}K';
//             },
//           ),
//         ),
//         minX: 0,
//         maxX: (spots.length - 1).toDouble(),
//         minY: 0,
//         maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2),
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             colors: _getColorForAmount(spots),
//             barWidth: 3,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(
//               show: true,
//               colors: spots.map((spot) {
//                 final currentMonthTotalAmount = spots.last.y;
//                 const lowAmountThreshold = 1000; // Adjust this value as needed
//                 final middleAmountThreshold = currentMonthTotalAmount / 1;

//                 if (spot.y < lowAmountThreshold) {
//                   return const Color.fromARGB(255, 173, 61, 61)
//                       .withOpacity(0.5);
//                 } else if (spot.y < middleAmountThreshold) {
//                   return const Color.fromARGB(255, 31, 152, 168)
//                       .withOpacity(0.5);
//                 } else {
//                   return const Color.fromARGB(255, 69, 172, 69)
//                       .withOpacity(0.5);
//                 }
//               }).toList(),
//             ),
//           ),
//         ],
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//             tooltipBgColor: Colors.transparent,
//             getTooltipItems: (spots) {
//               return spots.map((spot) {
//                 return LineTooltipItem(
//                   '₱${spot.y.toStringAsFixed(2)}',
//                   const TextStyle(color: Colors.black),
//                 );
//               }).toList();
//             },
//           ),
//           handleBuiltInTouches: true,
//         ),
//       ),
//     );
//   }

//   List<Color> _getColorForAmount(List<FlSpot> spots) {
//     final currentMonthTotalAmount = spots.last.y;
//     final lowAmountThreshold = 1000; // Adjust this value as needed

//     return spots.map((e) {
//       if (e.y < lowAmountThreshold) {
//         return const Color.fromARGB(255, 203, 35, 35);
//       } else if (e.y == currentMonthTotalAmount) {
//         return Colors.blue;
//       } else {
//         return Colors.green;
//       }
//     }).toList();
//   }
// }
