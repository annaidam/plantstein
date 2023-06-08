import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class TemperatureChart extends StatefulWidget {
  final int potId;
  const TemperatureChart(this.potId, {super.key});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  Future<List> getStats() async {
    var url = Uri.http(dotenv.env["SERVER"]!, 'plant/get/${widget.potId}');
    final response = await http.get(url);
    var url2 = Uri.http(dotenv.env["SERVER"]!,
        'room/condition/${jsonDecode(response.body)["room"]["id"]}/7');
    final response2 = await http.get(url2);
    final jsonData = jsonDecode(response2.body);
    List result = [];
    for (var element in jsonData) {
      result.add([element["weekday"], element["temperature"]]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        List stats = snapshot.data!;
        int len = stats.length;

        return Container(
          margin: const EdgeInsets.only(bottom: 30.0, top: 10.0),
          height: 160,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 8,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: getDataPoints(stats, len),
                  isCurved: true,
                  barWidth: 2,
                  color: const Color(0xFFCE9E8E),
                  dotData: FlDotData(
                    show: false,
                  ),
                )
              ],
              borderData: FlBorderData(
                border: const Border(
                  bottom: BorderSide(),
                ),
              ),
              gridData: FlGridData(
                show: true,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      switch (value.toInt()) {
                        case 1:
                          text = "M";
                          break;
                        case 2:
                          text = "T";
                          break;
                        case 3:
                          text = "W";
                          break;
                        case 4:
                          text = "T";
                          break;
                        case 5:
                          text = "F";
                          break;
                        case 6:
                          text = "S";
                          break;
                        case 7:
                          text = "S";
                          break;
                        default:
                          return Container();
                      }
                      return Text(
                        text,
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFF474847),
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<FlSpot> getDataPoints(List ls, int length) {
  Map<String, int> days = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7
  };

  int n = min(length, days[ls[0][0]]!);

  List<FlSpot> result = [];
  for (int i = 0; i < n; i++) {
    result.add(FlSpot(days[ls[i][0]]!.toDouble(), ls[i][1] / 5));
  }
  return result;
}
