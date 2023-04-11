import 'package:flutter/material.dart';

import 'test/main_layout.dart';

void main() async{
  runApp(MyGrillApp());
}

class MyGrillApp extends StatelessWidget {
  const MyGrillApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      routes: {
        '/mainlayout': (context) => MainLayout(),
        '/page1': (context) => Page1(),
        '/page2': (context) => Page1(),
        '/page3': (context) => Page1(),
        '/page4': (context) => Page1(),

      },
      initialRoute: '/mainlayout',
    );
  }
}
