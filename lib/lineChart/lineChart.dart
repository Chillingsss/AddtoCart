import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _lineChartSpots = [];
  List<String> _monthLabels = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesMonthData();
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
          _lineChartSpots = data.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            double value =
                double.tryParse(item['totalAmount'].toString()) ?? 0.0;

            return FlSpot(index.toDouble(), value);
          }).toList();

          _monthLabels = data.map<String>((item) {
            String month = item['month'].toString();
            return _getShortMonth(month);
          }).toList();
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

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.white, // Background color
        borderData: FlBorderData(
          show: true, // Show the border
          border: Border(
            top: BorderSide(
              color: Colors.red, // Top border color
              width: 2, // Top border width
            ),
            bottom: BorderSide(
              color: Colors.green, // Bottom border color
              width: 2, // Bottom border width
            ),
            left: BorderSide(
              color: Colors.blue, // Left border color
              width: 2, // Left border width
            ),
            right: BorderSide(
              color: Colors.yellow, // Right border color
              width: 2, // Right border width
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval:
              (_lineChartSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) *
                      1.1) /
                  5,
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
            interval: 1, // Ensure it shows every month label
            getTitles: (value) {
              int index = value.toInt();
              if (index >= 0 && index < _monthLabels.length) {
                return _monthLabels[index];
              } else {
                return '';
              }
            },
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (_lineChartSpots
                        .map((e) => e.y)
                        .reduce((a, b) => a > b ? a : b) *
                    1.1) /
                5,
            getTitles: (value) {
              if (value == 0) {
                return '';
              }
              return '${(value / 1000).toStringAsFixed(0)}K';
            },
          ),
        ),
        minX: 0,
        maxX: (_lineChartSpots.length - 1).toDouble(),
        minY: 0,
        maxY: (_lineChartSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) *
            1.2),
        lineBarsData: [
          LineChartBarData(
            spots: _lineChartSpots,
            isCurved: true,
            colors: _getColorForAmount(_lineChartSpots),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: _lineChartSpots.map((spot) {
                final currentMonthTotalAmount = _lineChartSpots.last.y;
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
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
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
    final currentMonthTotalAmount = spots.isNotEmpty ? spots.last.y : 0.0;
    const lowAmountThreshold = 1000; // Adjust this value as needed

    return spots.map((e) {
      if (e.y < lowAmountThreshold) {
        return const Color.fromARGB(255, 203, 35, 35);
      } else if (e.y == currentMonthTotalAmount) {
        return Colors.blue;
      } else {
        return Colors.green;
      }
    }).toList();
  }
}
