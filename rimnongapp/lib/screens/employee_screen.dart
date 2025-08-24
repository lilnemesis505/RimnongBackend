import 'package:flutter/material.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('คำสั่งซื้อ')),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('ลูกค้า: สมชาย'),
              subtitle: Text('น้ำส้ม x2'),
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: อัปเดตสถานะ
                },
                child: Text('เสร็จแล้ว'),
              ),
            ),
          ),
          // เพิ่มรายการอื่นๆ
        ],
      ),
    );
  }
}
