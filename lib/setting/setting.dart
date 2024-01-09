import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تنظیمات', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            DatabaseHelper dbHelper = DatabaseHelper();
            bool backupResult = await dbHelper.backupDatabase();
            if(backupResult){
              QuickAlert.show(
                title: "",
                text: "از داده های ذخیره شده در مدیریت فایل پشتیبان گرفته شد",
                type: QuickAlertType.info,
                context: context,
              );
            }
          },
          icon: Icon(Icons.backup),
          label: Text(
            'پشتیبان گیری',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
