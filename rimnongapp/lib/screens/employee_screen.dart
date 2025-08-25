import 'package:flutter/material.dart';
import 'package:rimnongapp/screens/auth/login_screen.dart'; // อย่าลืม import หน้า Login

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('คำสั่งซื้อ')),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                '👤 พนักงาน: ลิล',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
              onTap: () {
                // กลับไปหน้า Login และล้าง stack
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
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('ลูกค้า: สมชาย'),
              subtitle: const Text('น้ำส้ม x2'),
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: อัปเดตสถานะ
                },
                child: const Text('เสร็จแล้ว'),
              ),
            ),
          ),
          // เพิ่มรายการอื่นๆ
        ],
      ),
    );
  }
}