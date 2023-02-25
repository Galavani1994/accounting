import 'package:accounting/customer/CustomeList.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'product/ProductList.dart';

class AccountingBottomNavigator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.white,
      notchMargin: 10.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween/**/,
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width/2-20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductList()),
                    );
                  }, icon: Icon(Icons.production_quantity_limits_sharp,color: Colors.blueGrey[600],)),
                  IconButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CustomerList()),
                    );
                  }, icon: Icon(Icons.person_add_alt_rounded,color: Colors.blueGrey[600],)),
                ],
              ),/**/
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width/2-20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.search,color: Colors.blueGrey[600],),
                  Icon(Icons.shopping_basket,color: Colors.blueGrey[600],),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

