import 'package:accounting/product/Product.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../util/DatabaseHelper.dart';
import 'ProductEdit.dart';
import 'ProductService.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _formKey = GlobalKey<FormState>();
  List<Product>? products;
  ProductService productService = ProductService();
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // Use 'await' to wait for the result of the asynchronous operation
    List<Product> fetchedProducts = await productService.fetchProducts();
    setState(() {
      // Update the state with the fetched data
      products = fetchedProducts;
    });
  }

  List<Product> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('لیست محصولات',style: TextStyle(fontFamily: 'Vazir'),),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductEdit()),
                ).then((_) => refreshList());
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: buildSearchBar(),
          ),
        ),
        body: products == null
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
                  searchResults = products!
                      .where((product) => (product.fullName.toLowerCase().contains(query.toLowerCase())))
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
        itemCount: searchResults.isEmpty ? products!.length : searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults.isEmpty ? products![index] : searchResults[index];
          return Card(
            elevation: 2, // Add elevation for a shadow effect
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margins
            child: ListTile(
              title: Text(
                product.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                product.description,
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
                _showPopupMenu(context, product);
              },
              // Add more details or customize the ListTile as needed
            ),
          );
        },
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Product product) async {
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
                leading: Icon(Icons.edit),
                title: Text('ویرایش'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductEdit(product: product,),
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
                  _showDeleteConfirmation(context, product);
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    QuickAlert.show(
      type: QuickAlertType.confirm,
      context: context,
      title: "",
      text: "آیا از پاک کردن اطلاعات مطمئن هستید؟",
      onConfirmBtnTap: () async {
        try {
          await productService.deleteCustomer(product.id.toString());
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
    List<Product> updatedCustomers = await productService.fetchProducts();
    setState(() {
      products = updatedCustomers;
    });
  }
}
