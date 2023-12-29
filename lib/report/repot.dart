import 'package:flutter/material.dart';

import 'SimpleChart.dart';

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDynamicAppBar(),
      body: Center(
        child: SimpleChart(),
      ),
    );
  }

  PreferredSizeWidget buildDynamicAppBar() {
    return AppBar(
      title: Text(
        'گزارشات مالی',
        style: TextStyle(fontFamily: 'Vazir'),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
    );
  }
}
