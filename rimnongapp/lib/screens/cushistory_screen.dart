import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rimnongapp/models/order.dart';

class CusHistoryScreen extends StatefulWidget {
  final int? cusId;

  const CusHistoryScreen({Key? key, this.cusId}) : super(key: key);

  @override
  State<CusHistoryScreen> createState() => _CusHistoryScreenState();
}

class _CusHistoryScreenState extends State<CusHistoryScreen> {
  List<Order> historyOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistoryOrders();
  }

  // ดึงประวัติคำสั่งซื้อทั้งหมดของลูกค้าคนนี้
  Future<void> fetchHistoryOrders() async {
    setState(() {
      isLoading = true;
    });

    if (widget.cusId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2/api/fetch_cushistory.php?cus_id=${widget.cusId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          historyOrders = data.map((json) => Order.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load history orders');
      }
    } catch (e) {
      print('Error fetching history orders: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
                Text('วันที่สั่ง: ${order.orderDate}'),
                Text('ราคารวม: ฿${order.totalPrice.toStringAsFixed(2)}'),
                if (order.promoCode != null) Text('โค้ดโปรโมชัน: ${order.promoCode}'),
                if (order.remarks != null && order.remarks!.isNotEmpty) Text('หมายเหตุ: ${order.remarks}'),
                const Divider(),
                const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.orderDetails.map((detail) => Text('- ${detail.proName} x${detail.amount} (฿${detail.payTotal.toStringAsFixed(2)})')),
                const Divider(),
                if (order.isCompleted) Text('พนักงานที่รับออเดอร์: ${order.customerName}'),
                if (order.isCompleted) Text('วันที่รับออเดอร์: ${order.orderDate}'),
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
        title: const Text('คำสั่งซื้อของฉัน'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyOrders.isEmpty
              ? const Center(child: Text('ไม่มีประวัติการทำรายการ'))
              : ListView.builder(
                  itemCount: historyOrders.length,
                  itemBuilder: (context, index) {
                    final order = historyOrders[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () => _showOrderDetails(order),
                        ),
                        title: Text('คำสั่งซื้อ #${order.orderId}'),
                        subtitle: Text('รวมทั้งหมด: ฿${order.totalPrice.toStringAsFixed(2)}'),
                        trailing: order.isCompleted
                            ? const Text('เสร็จสิ้นแล้ว', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                            : const Text('กำลังทำรายการ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
    );
  }
}
