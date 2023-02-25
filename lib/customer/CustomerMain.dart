import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/customer/CustomerEdit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Customer.dart';

class CustomerMain extends StatelessWidget {

  Customer? customer;

  CustomerMain({this.customer});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_circle),text:"مشتری"),
                Tab(icon: Icon(Icons.store),text: "مالی",)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CustomerEdit(customer: customer,),
              Icon(Icons.music_video),
            ],
          ),
        ),
      ),
    );
  }
}
