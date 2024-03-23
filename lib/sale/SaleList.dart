import 'dart:io';

import 'package:accounting/sale/SaleDetail.dart';
import 'package:accounting/sale/sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quickalert/quickalert.dart';

import 'SaleEdit.dart';
import 'SaleService.dart';

class SaleList extends StatefulWidget {
  int customerId;

  SaleList(this.customerId);

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  var totalCreditorByCustomerId = "";
  var totalDebtorByCustomerId = "";
  int total = 0;
  late int creditor = 0;
  late int debtor = 0;
  var formatter = NumberFormat('#,###,000');
  var customerFullName = '';
  Future<List<Sale>>? list = null;

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();
    saleService.getDebtorTotalByPersonId(widget.customerId).then((value) =>
    {
      setState(() {
        debtor = value!;
      })
    });
    saleService.getCreditorTotalByPersonId(widget.customerId).then((value) =>
    {
      setState(() {
        creditor = value!;
      })
    });

    saleService.getCustomerFullNameById(widget.customerId).then((value) =>
    {
      setState(() {
        customerFullName = value!;
      })
    });

    saleService.fetchSales(widget.customerId).then((value) {
      setState(() {
        list = Future.value(value);
      });
    });

    total = (debtor == null ? 0 : debtor) - (creditor == null ? 0 : creditor);
    if (creditor != null) {
      totalCreditorByCustomerId = formatter.format(creditor);
    } else {
      totalCreditorByCustomerId = "0";
    }
    if (debtor != null) {
      totalDebtorByCustomerId = formatter.format(debtor);
    } else {
      totalDebtorByCustomerId = "0";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('صورتحساب ${customerFullName}'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.print, size: 30),
            onPressed: () {
              generatePdf(list!, customerFullName, totalCreditorByCustomerId,
                  totalDebtorByCustomerId, total);
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height - 270,
        child: Center(
          child: FutureBuilder<List<Sale>>(
            future: saleService.fetchSales(widget.customerId),
            builder:
                (BuildContext context, AsyncSnapshot<List<Sale>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("مشکل دیتا بیسی"),
                );
              }
              return snapshot.data!.isEmpty
                  ? Center(
                child: Text(
                  "دیتایی برای نمایش وجود ندارد",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
              )
                  : ListView(
                children: snapshot.data!.map((sale) {
                  return Center(
                    child: Card(
                      child: ListTile(
                        onLongPress: () {
                          _showPopupMenu(context, sale);
                        },
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    //this right here
                                    child: Container(
                                        height: 300,
                                        width: 300.0,
                                        child: SaleDetail(
                                          entity: sale,
                                        )),
                                  ));
                        },
                        title: Container(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          QuickAlert.show(
                                              type:
                                              QuickAlertType.confirm,
                                              context: context,
                                              title: "",
                                              text:
                                              "آیا از پاک کردن اطلاعات مطمئن هستید؟",
                                              onConfirmBtnTap: () {
                                                saleService.deleteSale(
                                                    sale.id.toString());
                                                Navigator.of(context,
                                                    rootNavigator:
                                                    true)
                                                    .pop();
                                              },
                                              confirmBtnText: "بلی",
                                              cancelBtnText: "خیر");
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        )),
                                    /*IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SaleEdit(
                                                              sale: sale,
                                                            )));
                                              },
                                              icon: Icon(Icons.edit)),*/
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        sale.createDate.toString() +
                                            ' - ' +
                                            (sale.creditor != null &&
                                                sale.creditor == true
                                                ? 'بس'
                                                : 'بد'),
                                        style: TextStyle(
                                            fontFamily: "Vazir",
                                            fontSize: 14)),
                                    Text(
                                      " تعداد : " +
                                          (sale.quantity == null
                                              ? "0"
                                              : sale.quantity)
                                              .toString() +
                                          " قیمت : " +
                                          (sale.price == null
                                              ? "0"
                                              : formatter
                                              .format(sale.price))
                                              .toString(),
                                      style: TextStyle(
                                          fontFamily: "Vazir",
                                          fontSize: 12),
                                    ),
                                    Text(
                                      " تخفیف : " +
                                          (sale.discount == null
                                              ? "0"
                                              : formatter.format(
                                              sale.discount))
                                              .toString() +
                                          " جمع : " +
                                          (sale.total == null
                                              ? "0"
                                              : formatter.format(
                                              double.parse(sale
                                                  .total
                                                  .toString())))
                                              .toString() +
                                          " پرداختی : " +
                                          (sale.payment == null
                                              ? "0"
                                              : formatter.format(
                                              sale.payment))
                                              .toString(),
                                      style: TextStyle(
                                          fontFamily: "Vazir",
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  مانده بستانکار : " + totalCreditorByCustomerId,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " مانده بدهی : " + totalDebtorByCustomerId,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "  مانده کل : " +
                          '  ' +
                          formatter.format(total.abs()) +
                          ' ' +
                          (total > 0 ? ' بدهکار ' : 'بستانکار'),
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Sale sale) async {
    final RenderBox overlay =
    Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(10, MediaQuery
            .of(context)
            .size
            .height),
        Offset(10, MediaQuery
            .of(context)
            .size
            .height),
      ),
      Rect.fromLTRB(0, 0, overlay.size.width, overlay.size.height),
    );
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('ویرایش'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SaleEdit(
                          entity: sale,
                        ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<void> generatePdf(Future<List<Sale>> salesFuture,
      String customerFullName,
      String creditor,
      String debtor,
      int total,) async {
    final List<Sale> sales = await salesFuture;

    final String folderName = 'sale-report-file';
    final Directory customFolder =
    Directory("storage/emulated/0/hesabDaftari/$folderName");
    if (!customFolder.existsSync()) {
      customFolder.createSync(recursive: true);
    }

    final font = await rootBundle.load("fonts/Vazirmatn-Medium.ttf");
    final pw.Font ttf = pw.Font.ttf(font);

    final pdf = pw.Document();

    int currentIndex = 0;
    while (currentIndex < sales.length) {
      final endIndex = (currentIndex + 10 < sales.length) ? currentIndex + 10 : sales.length;
      List<Sale> sale_ = sales.sublist(currentIndex, endIndex);
      pdf.addPage(
        pw.Page(
          theme: pw.ThemeData.withFont(base: ttf),
          build: (pw.Context context) =>
              _buildPageContent(
              sale_,
              ttf,
              debtor,
              creditor,
              total,
              ),
        ),
      );

      currentIndex += 10;
    }

    final String filePath = '${customFolder.path}/${customerFullName}.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    QuickAlert.show(
      title: "",
      text: "صورت حساب در مسیر \n ${filePath}\n ذخیره شد ",
      type: QuickAlertType.success,
      context: context,
    );
  }

  pw.Widget _buildPageContent(List<Sale> sales,
      pw.Font ttf,
      String debtor,
      String creditor,
      int total,) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: _buildHeaderRow(ttf),
        ),
        ...sales
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final sale = entry.value;
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: _buildDataRow(index + 1, sale), // Add 1 to index for display
          );
        }).toList(),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: _buildFooterRow(debtor, creditor),
        ),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('جمع کل : ${formatter.format(total)} ${total>0?'بدهکار':'بستانکار'}'),
            ],
          ),
        ),
      ],
    );
  }

  pw.Container _buildHeaderRow(pw.Font ttf) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1),color: PdfColors.amber200),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderCell('ردیف', ttf, 35),
          _buildHeaderCell('عنوان', ttf, 80),
          _buildHeaderCell('مشخصات', ttf, 100),
          _buildHeaderCell('پرداختی', ttf, 60),
          _buildHeaderCell('تاریخ', ttf, 75),
        ],
      )
    );
  }

  pw.Container _buildHeaderCell(String text, pw.Font fnt, double width) {
    return pw.Container(
      width: width,
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: fnt),
      ),
    );
  }

  pw.Container _buildDataRow(int index, Sale sale) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildCell('$index', 35), // Display index
          _buildCell('${(sale.product_title==null || sale.product_title=='')? 'شناسه ${sale.product_id}':sale.product_title}', 80),
          _buildCell('مقدار : ${sale.quantity} \n قیمت : ${formatter.format(sale.price)}\nتخفیف : ${formatter.format(sale.discount)}\nجمع : ${formatter.format(int.parse(sale.total!))}', 100),
          _buildCell('${formatter.format(sale.payment!)}', 60),
          _buildCell('${sale.createDate!}', 75),
        ],
      ),
    );
  }

  pw.Container _buildCell(String text, double width) {
    return pw.Container(
      width: width,
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(text),
    );
  }

  pw.Row _buildFooterRow(String debtor, String creditor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('مانده بدهی: $debtor'),
        pw.Text('مانده بستانکار : $creditor'),
      ],
    );
  }
}
