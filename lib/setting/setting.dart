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
            int backupResult = await dbHelper.backupDatabase();
            if(backupResult==1){
              QuickAlert.show(
                title: "",
                text: "از پایگاه داده در مدیریت فایل در پوشه acc_back پشتیبان گرفته شد.",
                type: QuickAlertType.success,
                context: context,
              );
            }else if(backupResult==13){
              QuickAlert.show(
                title: "",
                text: "در تتنظمات > مدیریت برنامه > بخش دسترسی ، دسترسی های لازم را جهت گرفتن پشتیبان بدهید",
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
