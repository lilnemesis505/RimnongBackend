import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
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
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_drink),
              title: Text('เมนูเครื่องดื่ม'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('คำสั่งซื้อของฉัน'),
              onTap: () {
                // TODO: ไปหน้าคำสั่งซื้อ
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () {
                // TODO: logout
              },
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
            onPressed: () {
              // TODO: ไปหน้าตะกร้า
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.local_drink, color: Colors.orange),
              title: Text('น้ำส้ม'),
              subtitle: Text('ราคา 25 บาท'),
              trailing: ElevatedButton(
                child: Text('สั่งซื้อ'),
                onPressed: () {
                  // TODO: สั่งน้ำส้ม
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_drink, color: Colors.green),
              title: Text('น้ำใบเตย'),
              subtitle: Text('ราคา 20 บาท'),
              trailing: ElevatedButton(
                child: Text('สั่งซื้อ'),
                onPressed: () {
                  // TODO: สั่งน้ำใบเตย
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
