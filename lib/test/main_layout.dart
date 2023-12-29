import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/report/repot.dart';
import 'package:accounting/sale/Add.dart';
import 'package:accounting/setting/setting.dart';
import 'package:flutter/material.dart';

import '../product/ProductList.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 2;

  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();
  final _page4 = GlobalKey<NavigatorState>();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              Navigator(
                key: _page1,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => ProductList(),
                ),
              ),
              Navigator(
                key: _page2,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => CustomerList(),
                ),
              ),
              Navigator(
                key: _page3,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Report(),
                ),
              ),
              Navigator(
                key: _page4,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Setting(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red[900],
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits_sharp),
                label: 'محصولات',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_add_alt_rounded), label: 'مشتریان'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.report), label: 'گزارشات'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'تنظیمات'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red[900],
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0)), //this right here
                          child: Container(
                              height: MediaQuery.of(context).size.height - 250,
                              width: 400.0,
                              child: Add()),
                        ));
              },
              child: Icon(Icons.wallet)),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  DateTime? _lastBackPressedTime;

  Future<bool> _onBackPressed(BuildContext context) {
    
    print('iam here');
    DateTime currentTime = DateTime.now();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 100,
        child: Text('Press back again to exit'),
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Perform an action when the user presses the "Undo" button
        },
      ),
    ));
    // If back button was pressed twice within 2 seconds, exit the app
    if (_lastBackPressedTime == null || currentTime.difference(_lastBackPressedTime!) > Duration(seconds: 2)) {
      _lastBackPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SizedBox(
          height: 100,
           child: Text('Press back again to exit'),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Perform an action when the user presses the "Undo" button
          },
        ),
      ));
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
