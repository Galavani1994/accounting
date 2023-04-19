import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SimpleChart extends StatelessWidget {


  SimpleChart();

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "وصول شده": 19000000,
      "مانده بدهی": 25000000,
      "پرداخت شده": 21000000,
    };
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
                child: PieChart(dataMap: dataMap,
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
                  ),
                )
            )
        )
    );
  }

}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}