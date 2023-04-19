import 'package:flutter/material.dart';

import 'SimpleChart.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('گزارشات مالی',style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
      ),
      body: Center(
        child: SimpleChart(),
      ),
    );
  }
}
