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
                text: "از پایگاه داده در مدیریت فایل در پوشه\nacc_back"
                    "\nپشتیبان گرفته شد",
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
      bottomSheet: Container(
        alignment: Alignment.bottomLeft,transformAlignment: Alignment.bottomLeft,
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("developed by : Mahdi Galavani",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),),
                  ],
                ),
                Row(
                  children: [
                    Text("call : +98 914 543 5507",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            )),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
