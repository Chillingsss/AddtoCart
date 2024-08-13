// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  List<FlSpot> _lineChartSpots = [];
  List<BarChartGroupData> _chartData = [];
  List<String> _productNames = [];
  List<String> _monthLabels = [];
  double thisMonthSales = 0.0;
  double lastMonthSales = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
    _fetchThisMonthSales();
    _fetchLastMonthSales();
    _fetchSalesMonthData();
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
        print('Fetched data: $data'); // Log the data

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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Logout logic here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _chartData.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 212, 212, 212),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        width: 500,
                        height: 350,
                        child: Row(
                          children: [
                            Expanded(
                              child: BarChartWidget(
                                chartData: _chartData,
                                productNames: _productNames,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                        )),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 16,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SalesInfoCard(
                  thisMonthSales: thisMonthSales,
                  lastMonthSales: lastMonthSales,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 550, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  child: LineChartWidget(
                    spots: _lineChartSpots,
                    monthLabels: _monthLabels,
                  ),
                ),
              ],
            ),
          ),
        ],
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

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> monthLabels;

  LineChartWidget({super.key, required this.spots, required this.monthLabels});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval:
              (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1) / 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade400,
              strokeWidth: 0.5,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade400,
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: false,
            reservedSize: 40,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitles: (value) {
              int index = value.toInt();
              if (index < monthLabels.length) {
                return monthLabels[index];
              } else {
                return '';
              }
            },
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval:
                (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1) /
                    5,
            getTitles: (value) {
              if (value == 0) {
                return '';
              }
              return '${(value / 1000).toStringAsFixed(0)}K';
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: const Color.fromARGB(255, 52, 71, 87), width: 1),
        ),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: _getColorForAmount(spots),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: spots.map((spot) {
                final currentMonthTotalAmount = spots.last.y;
                const lowAmountThreshold = 1000; // Adjust this value as needed
                final middleAmountThreshold = currentMonthTotalAmount / 1;

                if (spot.y < lowAmountThreshold) {
                  return const Color.fromARGB(255, 173, 61, 61)
                      .withOpacity(0.5);
                } else if (spot.y < middleAmountThreshold) {
                  return const Color.fromARGB(255, 31, 152, 168)
                      .withOpacity(0.5);
                } else {
                  return const Color.fromARGB(255, 69, 172, 69)
                      .withOpacity(0.5);
                }
              }).toList(),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '₱${spot.y.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.black),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  List<Color> _getColorForAmount(List<FlSpot> spots) {
    final currentMonthTotalAmount = spots.last.y;
    final lowAmountThreshold = 1000; // Adjust this value as needed

    return spots.map((e) {
      if (e.y < lowAmountThreshold) {
        return Color.fromARGB(255, 203, 35, 35);
      } else if (e.y == currentMonthTotalAmount) {
        return Colors.blue;
      } else {
        return Colors.green;
      }
    }).toList();
  }
}
