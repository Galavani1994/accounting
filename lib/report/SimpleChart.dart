/*import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' show Random;*//*


class SimpleChart extends StatelessWidget {
  SimpleChart();

  Map<String, double> generateRandomData() {
    Random random = Random();
    Map<String, double> dataMap = {
      "بدهکار": random.nextDouble() * 100000000,
      "بسانکار": random.nextDouble() * 100000000,
    };

    // Format numbers within the dataMap
    dataMap.forEach((key, value) {
      dataMap[key] = double.parse(formatNumber(value));
    });

    return dataMap;
  }

  String formatNumber(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = generateRandomData();

    final gradientList = <List<Color>>[
      [
        Color.fromARGB(255, 231, 197, 26),
        Color.fromARGB(200, 182, 155, 65),
      ],
      [
        Color.fromARGB(255, 229, 95, 13),
        Color.fromARGB(200, 201, 152, 123),
      ],
      [
        Color.fromARGB(255, 27, 157, 48),
        Color.fromARGB(200, 122, 182, 141),
      ]
    ];
    final colorList = <Color>[
      Colors.deepPurple,
    ];

    return Scaffold(
      body: Center(
        child: Container(
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 2000),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: colorList,
            initialAngleInDegree: 0,
            ringStrokeWidth: 32,
            centerText: "",
            gradientList: gradientList,
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
              chartValueStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
