import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../sale/SaleList.dart';
import '../util/DatabaseHelper.dart';
import 'Customer.dart';
import 'CustomerEdit.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final _formKey = GlobalKey<FormState>();
  List<Customer>? customers;
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    dbHelper = DatabaseHelper();

    // Use 'await' to wait for the result of the asynchronous operation
    List<Customer> fetchedCustomers = await dbHelper.fetchCustomers();

    setState(() {
      // Update the state with the fetched data
      customers = fetchedCustomers;
    });
  }

  List<Customer> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('لیست مشتریان',style: TextStyle(fontFamily: 'Vazir'),),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerEdit()),
                ).then((_) => refreshList());
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: buildSearchBar(),
          ),
        ),
        body: customers == null
            ? Center(child: CircularProgressIndicator())
            : buildBody(),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  // Implement your search logic here
                  searchResults = customers!
                      .where((customer) => (customer.first_name
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                      customer.last_name
                          .toLowerCase()
                          .contains(query.toLowerCase())))
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        itemCount: searchResults.isEmpty ? customers!.length : searchResults.length,
        itemBuilder: (context, index) {
          final customer = searchResults.isEmpty ? customers![index] : searchResults[index];
          return Card(
            elevation: 2, // Add elevation for a shadow effect
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margins
            child: ListTile(
              title: Text(
                customer.first_name + ' ' + customer.last_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                customer.phone_number,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              leading: CircleAvatar(
                // You can customize the leading widget (e.g., display an image)
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onLongPress: () {
                _showPopupMenu(context, customer);
              },
              // Add more details or customize the ListTile as needed
            ),
          );
        },
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Customer customer) async {
    final RenderBox overlay =
    Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(10, MediaQuery.of(context).size.height),
        Offset(10, MediaQuery.of(context).size.height),
      ),
      Rect.fromLTRB(0, 0, overlay.size.width, overlay.size.height),
    );
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('صورتحساب'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaleList(customer.id!),
                    ),
                  );
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('ویرایش'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerEdit(
                        customer: customer,
                      ),
                    ),
                  ).then((_) => refreshList());
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('پاک کردن'),
                onTap: () {
                  _showDeleteConfirmation(context, customer);
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Customer customer) {
    QuickAlert.show(
      type: QuickAlertType.confirm,
      context: context,
      title: "",
      text: "آیا از پاک کردن اطلاعات مطمئن هستید؟",
      onConfirmBtnTap: () async {
        try {
          await dbHelper.deleteCustomer(customer.id.toString());
          refreshList();
        } catch (e) {
          print('Error deleting customer: $e');
          // Handle the error, e.g., display an error message
        }
        Navigator.of(context, rootNavigator: true).pop();
      },
      confirmBtnText: "بلی",
      cancelBtnText: "خیر",
    );
  }

  void refreshList() async {
    List<Customer> updatedCustomers = await dbHelper.fetchCustomers();
    setState(() {
      customers = updatedCustomers;
    });
  }
}
