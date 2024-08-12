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
  List<BarChartGroupData> _chartData = [];
  List<String> _productNames = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
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
      body: _chartData.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 212, 212, 212),
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
                          children: _productNames.asMap().entries.map((entry) {
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
