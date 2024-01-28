import 'package:accounting/util/DatabaseHelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  Future<void> pickBackupFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any// Specify the allowed file extension(s)
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      print("Selected file: $filePath");

      DatabaseHelper dbHelper = DatabaseHelper();
      int importResult = await dbHelper.importDatabase(filePath);
      if (importResult == 1) {
        QuickAlert.show(
          title: "",
          text: "پایگاه داده با موفقیت وارد شد.",
          type: QuickAlertType.success,
          context: context,
        );
      } else if (importResult == 13) {
        QuickAlert.show(
          title: "",
          text: "در تنظیمات > مدیریت برنامه > بخش دسترسی ، دسترسی های لازم را جهت وارد کردن پشتیبان بدهید",
          type: QuickAlertType.info,
          context: context,
        );
      }
    } else {
      // User canceled the file picking
      print("File picking canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('تنظیمات', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child:  Column(
          children: [
            ElevatedButton.icon(
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
            SizedBox(height: 20), // Add some space between buttons
            ElevatedButton.icon(
              onPressed: () async {
                await pickBackupFile();

                /*DatabaseHelper dbHelper = DatabaseHelper();
                int importResult = await dbHelper.importDatabase();
                if (importResult == 1) {
                  QuickAlert.show(
                    title: "",
                    text: "پایگاه داده با موفقیت وارد شد.",
                    type: QuickAlertType.success,
                    context: context,
                  );
                } else if (importResult == 13) {
                  QuickAlert.show(
                    title: "",
                    text: "در تنظیمات > مدیریت برنامه > بخش دسترسی ، دسترسی های لازم را جهت وارد کردن پشتیبان بدهید",
                    type: QuickAlertType.info,
                    context: context,
                  );
                }*/
              },
              icon: Icon(Icons.import_export),
              label: Text(
                'وارد کردن پشتیبان',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.bottomLeft,transformAlignment: Alignment.bottomLeft,
        height: 60,
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
