import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../sale/SaleService.dart';

class Report extends StatelessWidget {
  final SaleService saleService = SaleService();
  final formatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDynamicAppBar(),
      body: FutureBuilder<List<int?>>(
        future: Future.wait([
          saleService.getDebtorTotal(),
          saleService.getCreditorTotal(),
        ]),
        builder: (context, AsyncSnapshot<List<int?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final debtor = snapshot.data![0] ?? 0;
            final creditor = snapshot.data![1] ?? 0;

            return Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<ExpenseData, String>(
                      dataSource: getExpenseData(debtor, creditor),
                      xValueMapper: (data, _) => data.category,
                      yValueMapper: (data, _) => data.amount,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                      ),
                      // Set different colors for debtor and creditor slices
                      pointColorMapper: (data, _) =>
                      data.category.contains('بدهکار') ? Colors.deepPurple : Colors.lime[900],
                    ),
                  ],
                ),
              ),
            );
          }
        },
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

  List<ExpenseData> getExpenseData(int debtor, int creditor) {
    return [
      ExpenseData('بستانکار: ${formatter.format(creditor)}', creditor.toDouble()),
      ExpenseData('بدهکار : ${formatter.format(debtor)}', debtor.toDouble()),

    ];
  }
}

class ExpenseData {
  final String category;
  final double amount;

  ExpenseData(this.category, this.amount);
}
