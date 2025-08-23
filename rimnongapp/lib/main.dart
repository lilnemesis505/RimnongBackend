import 'package:flutter/material.dart';
import 'screens/customer_screen.dart';
import 'screens/employee_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Ordering',
      home: HomeSelector(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เลือกหน้าจอ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('ลูกค้า'),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CustomerScreen()));
              },
            ),
            ElevatedButton(
              child: Text('พนักงาน'),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EmployeeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
