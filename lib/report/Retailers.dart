import 'package:flutter/material.dart';

import '../sale/SaleList.dart';
import '../sale/SaleService.dart';
import '../sale/saleByType.dart';

class Retailers extends StatelessWidget {
  final int selectedIndex;

  const Retailers({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لیست ${selectedIndex == 0 ? 'بستانکاران' : 'بدهکاران'}',
            style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<List<SaleByType>>(
          future: SaleService().fetchCreditorOrDebtor(selectedIndex == null
              ? "DEBTOR"
              : selectedIndex == 0
                  ? "CREDITOR"
                  : "DEBTOR"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<SaleByType>? data = snapshot.data;

              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2, // Add elevation for a shadow effect
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleList(data[index].person_id!),
                          ),
                        );
                      },
                      title: Text(data[index].fullName.toString()),
                      subtitle: Text(
                          'بدهکار : ${formatAmount(data[index].debtor_amount.toString())}\nبستانکار : ${formatAmount(data[index].creditor_amount.toString())}\nمانده نهایی : ${formatAmount(data[index].total.toString())}'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  String formatAmount(String price) {
    String priceInText = "";
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String str = price[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = ",$str$priceInText";
      }
    }
    return priceInText.trim();
  }
}
