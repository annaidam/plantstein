import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LightChart extends StatefulWidget {
  final int potId;
  const LightChart(this.potId, {super.key});

  @override
  State<LightChart> createState() => _LightChartState();
}

class _LightChartState extends State<LightChart> {
  Future<List> getStats() async {
    var url = Uri.http(dotenv.env["SERVER"]!, 'plant/get/${widget.potId}');
    final response = await http.get(url);
    var url2 = Uri.http(dotenv.env["SERVER"]!,
        'room/condition/${jsonDecode(response.body)["room"]["id"]}/7');
    final response2 = await http.get(url2);
    final jsonData = jsonDecode(response2.body);
    List result = [];
    for (var element in jsonData) {
      result.add([element["weekday"], element["brightness"]]);
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
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: 20,
              minY: 1,
              groupsSpace: 26,
              barTouchData: BarTouchData(
                enabled: true,
              ),
              barGroups: getDataPoints(stats, len),
              borderData: FlBorderData(
                border: const Border(
                  bottom: BorderSide(),
                ),
              ),
              gridData: FlGridData(
                show: false,
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

List<BarChartGroupData> getDataPoints(List ls, int length) {
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

  List<BarChartGroupData> result = [];

  int firstDay = days[ls[0][0]]!;
  int lastDay = firstDay + length;
  for (int i = 1; i < 8; i++) {
    if (i >= firstDay && i < lastDay) {
      result.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: ls[i - firstDay][1] / 40,
            width: 20.0,
            color: const Color(0xFFEDD88E),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
          ),
        ],
      ));
    } else {
      result.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: 0,
            width: 20.0,
            color: const Color(0xFFEDD88E),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
          ),
        ],
      ));
    }
  }
  return result;
}
