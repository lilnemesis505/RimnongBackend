import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rimnongapp/screens/auth/login_screen.dart';
import 'package:rimnongapp/models/order.dart';
import 'package:rimnongapp/screens/emhistory_screen.dart'; // import หน้าใหม่

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Order> orders = [];
  bool isLoading = true;
  int? _emId;
  String _emName = 'พนักงาน'; // เพิ่มตัวแปรสำหรับเก็บชื่อพนักงาน
  String _emEmail = 'employee@example.com'; // ✅ เพิ่มตัวแปรสำหรับเก็บอีเมล

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emId = ModalRoute.of(context)?.settings.arguments as int?;
      if (_emId != null) {
        fetchEmployeeData(_emId!);
      }
      fetchOrders();
    });
  }

  // ดึงข้อมูลพนักงานจาก API
  Future<void> fetchEmployeeData(int emId) async {
    final url = Uri.parse('http://10.0.2.2/api/employee.php?em_id=$emId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _emName = data['em_name'];
            _emEmail = data['em_email']; // ✅ เก็บค่าอีเมลที่ได้จาก API
          });
        }
      }
    } catch (e) {
      print('Error fetching employee data: $e');
    }
  }

  // ดึงรายการคำสั่งซื้อที่รอดำเนินการจาก API
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/api/fetch_orders.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.map((json) => Order.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // อัปเดตสถานะคำสั่งซื้อเป็นเสร็จสิ้น
  Future<void> completeOrder(int orderId) async {
    final url = Uri.parse('http://10.0.2.2/api/complete_order.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId, 'em_id': _emId}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          final index = orders.indexWhere((order) => order.orderId == orderId);
          if (index != -1) {
            orders.removeAt(index);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('อัปเดตสถานะสำเร็จ')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'เกิดข้อผิดพลาดในการอัปเดต'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error completing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ฟังก์ชันสำหรับแสดงรายละเอียดคำสั่งซื้อใน Dialog
  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายละเอียดคำสั่งซื้อ #${order.orderId}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ลูกค้า: ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('วันที่สั่ง: ${order.orderDate}'),
                Text('ราคารวม: ฿${order.totalPrice.toStringAsFixed(2)}'),
                if (order.promoCode != null) Text('โค้ดโปรโมชัน: ${order.promoCode}'),
                if (order.remarks != null && order.remarks!.isNotEmpty) Text('หมายเหตุ: ${order.remarks}'),
                const Divider(),
                const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.orderDetails.map((detail) => Text('- ${detail.proName} x${detail.amount} (฿${detail.payTotal.toStringAsFixed(2)})')),
                const Divider(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำสั่งซื้อ'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchOrders,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView( // ✅ เปลี่ยน Column เป็น ListView เพื่อให้เลื่อนได้
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('พนักงาน: $_emName'), // ✅ แสดงชื่อพนักงาน
              accountEmail: Text(_emEmail), // ✅ แสดงอีเมลพนักงาน
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: const BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('ประวัติการทำรายการ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmHistoryScreen(emId: _emId)),
                );
              },
            ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('ไม่มีรายการคำสั่งซื้อที่รอดำเนินการ'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('คำสั่งซื้อ #${order.orderId}'),
                        subtitle: Text('ลูกค้า: ${order.customerName} | รวมทั้งหมด: ฿${order.totalPrice.toStringAsFixed(2)}'),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () => _showOrderDetails(order),
                        ),
                        trailing: order.isCompleted
                            ? const Text('เสร็จสิ้นแล้ว', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                            : ElevatedButton(
                                onPressed: () => completeOrder(order.orderId),
                                child: const Text('เสร็จแล้ว'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
