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
      },
      initialRoute: '/mainlayout',
    );
  }
}
