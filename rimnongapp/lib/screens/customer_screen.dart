import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String proId;
  final String proName;
  final double price;
  final String imageUrl; // ถ้ามีรูปภาพ

 Product({
    required this.proId,
    required this.proName,
    required this.price,
    required this.imageUrl,
  });


factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    proId: json['pro_id'],
    proName: json['pro_name'],
    price: double.parse(json['price']),
    imageUrl: json['image_url'], // ใช้จาก backend โดยตรง
  );
}

}


class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Product> products = [];
  bool isLoading = true;

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/api.php'));
  print('API Response: ${response.body}'); // Debug print
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('ลูกค้า'),
              accountEmail: Text('customer@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              leading: Icon(Icons.local_drink),
              title: Text('เมนูเครื่องดื่ม'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('คำสั่งซื้อของฉัน'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('เมนูเครื่องดื่ม'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()):
         GridView.builder(
  padding: EdgeInsets.all(16),
  itemCount: products.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) {
    final product = products[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child:Image.network(
  product.imageUrl,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    print('Image load error: $error');
    return Image.network('http://10.0.2.2/storage/products/no-image.png');
  },
)


            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  product.proName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  '฿${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.teal),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: สั่งซื้อสินค้า
                  },
                  child: Text('สั่งซื้อ'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36),
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
    );
  }
}
