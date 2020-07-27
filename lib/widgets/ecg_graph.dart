import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:patient/models/data.dart';
import 'package:provider/provider.dart';

class EcgGraph extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              textStyle: const TextStyle(
                  color: Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              getTitles: (value) {
                return '';
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: const TextStyle(
                color: Color(0xff67727d),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 240:
                    return '240';
                  case 180:
                    return '180';
                  case 120:
                    return '120';
                  case 60:
                    return '60';
                  case 0:
                    return '0';
                }
                return '';
              },
              reservedSize: 28,
              margin: 12,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minY: -3,
          maxY: 3,
          backgroundColor: Colors.black,
          lineBarsData: [
            LineChartBarData(
              spots: Provider.of<Data>(context, listen: true).ecgGraph,
              isCurved: false,
              colors: gradientColors,
              barWidth: 3,
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
