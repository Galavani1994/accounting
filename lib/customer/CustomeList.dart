import 'package:flutter/material.dart';
import 'package:accounting/customer/Customer.dart';
import 'package:accounting/customer/CustomerEdit.dart';
import 'package:accounting/sale/SaleList.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:quickalert/quickalert.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CustomerEdit()));
                  },
                ),
              ],
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
          title: Text(
            "لیست مشتریان",
            style: TextStyle(fontFamily: "Vazir"),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Open search bar
                showSearch(
                  context: context,
                  delegate: CustomerSearchDelegate(dbHelper.fetchCustomers()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Customer>>(
            future: dbHelper.fetchCustomers(),
            builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(""),
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
                children: snapshot.data!.map((customer) {
                  return GestureDetector(
                    onLongPress: () {
                      _showPopupMenu(context, customer, dbHelper);
                    },
                    child: Center(
                      child: Card(
                        child: ListTile(
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  customer.first_name,
                                  style: TextStyle(
                                      fontFamily: "Vazir", fontSize: 18),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  customer.phoneNumber,
                                  style: TextStyle(
                                      fontFamily: "Vazir", fontSize: 14),
                                ),
                              ],
                            ),
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
    );
  }

  void _showPopupMenu(BuildContext context, Customer customer, DatabaseHelper dbHelper) async {
    // ... (unchanged)
  }
}

class CustomerSearchDelegate extends SearchDelegate<List<Customer>> {
  final Future<List<Customer>> customers;

  CustomerSearchDelegate(this.customers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, []);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on the query
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<List<Customer>>(
      future: customers,
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<Customer> filteredCustomers = snapshot.data!
            .where((customer) => customer.first_name.contains(query) || customer.phoneNumber.contains(query))
            .toList();

        return ListView(
          children: filteredCustomers.map((customer) {
            return ListTile(
              title: Text(customer.first_name),
              subtitle: Text(customer.phoneNumber),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerEdit(customer: customer),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
