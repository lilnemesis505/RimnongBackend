import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rimnongapp/screens/auth/login_screen.dart';
import 'package:rimnongapp/screens/cart_screen.dart';
import 'package:rimnongapp/screens/cushistory_screen.dart'; // Import หน้า Cushistory
import 'package:rimnongapp/models/product.dart';
import 'dart:async'; // import เพื่อใช้ Timer

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Product> products = [];
  Map<Product, int> cart = {}; 
  bool isLoading = true;
  int? _cusId;
  String _cusName = 'ลูกค้า'; // เพิ่มตัวแปรสำหรับเก็บชื่อลูกค้า
  String _cusEmail = 'customer@example.com'; // เพิ่มตัวแปรสำหรับเก็บอีเมล

  // เพิ่มตัวแปรเพื่อเก็บสถานะคำสั่งซื้อที่เสร็จสิ้น
  int _completedOrdersCount = 0;

  void addToCart(Product product) {
    setState(() {
      cart.update(product, (value) => value + 1, ifAbsent: () => 1);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.proName} ถูกเพิ่มในตะกร้า'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/api.php'));
    print('API Response: ${response.body}');
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
  
  // ฟังก์ชันใหม่สำหรับตรวจสอบสถานะคำสั่งซื้อของลูกค้า
  Future<void> _checkOrderStatus() async {
    final url = Uri.parse('http://10.0.2.2/api/fetch_cushistory.php?cus_id=$_cusId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final int completedCount = data.where((order) => order['receive_date'] != null).length;
        
        if (completedCount > _completedOrdersCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ คำสั่งซื้อเสร็จสิ้น กรุณามารับเครื่องดื่มที่เคาน์เตอร์'),
              backgroundColor: Colors.green,
            ),
          );
        }
        setState(() {
          _completedOrdersCount = completedCount;
        });
      }
    } catch (e) {
      print('Error checking order status: $e');
    }
  }

  // ดึงข้อมูลลูกค้าจาก API
  Future<void> _fetchCustomerData(int cusId) async {
    final url = Uri.parse('http://10.0.2.2/api/customer.php?cus_id=$cusId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _cusName = data['fullname'];
            _cusEmail = data['email'];
          });
        }
      }
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cusId = ModalRoute.of(context)?.settings.arguments as int?;
      fetchProducts();
      if (_cusId != null) {
        _fetchCustomerData(_cusId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_cusName), // แสดงชื่อลูกค้าที่ดึงมาจาก API
              accountEmail: Text(_cusEmail), // แสดงอีเมลลูกค้าที่ดึงมาจาก API
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: const BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('เมนูเครื่องดื่ม'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('คำสั่งซื้อของฉัน'),
              onTap: () {
                // นำทางไปหน้า cushistory_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CusHistoryScreen(cusId: _cusId)),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('เมนูเครื่องดื่ม'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (_) => CartScreen(cart: cart, cusId: _cusId), // ใช้ตัวแปรของ State
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Image load error: $error');
                              return Image.network('http://10.0.2.2/storage/products/no-image.png');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              product.proName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '฿${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.teal),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => addToCart(product),
                              child: const Text('สั่งซื้อ'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36),
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
            ),
    );
  }
}
