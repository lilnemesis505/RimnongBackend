import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rimnongapp/screens/auth/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;

Future<void> login() async {
  setState(() => isLoading = true);

  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/api/auth.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': usernameCtrl.text,
        'password': passwordCtrl.text,
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Raw Body: ${response.body}');
    print('Body Type: ${response.body.runtimeType}');

    setState(() => isLoading = false);

    // Try decoding JSON safely
    final data = json.decode(response.body.trim());
    print('Decoded JSON: $data');

    if (data['status'] == 'success') {
      final role = data['role'];
      final id = data['id'];

      if (role == 'customer') {
        Navigator.pushReplacementNamed(context, '/customer', arguments: id);
      } else if (role == 'employee') {
        Navigator.pushReplacementNamed(context, '/employee', arguments: id);
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(data['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    print('Login Error: $e');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: const Text("Invalid response from server. Please try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Text(
                "เข้าสู่ระบบ",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
                        const SizedBox(height: 16), // ระยะห่างระหว่างปุ่ม
                TextButton(
                  onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
             );
            },
                 child: const Text(
              "สมัครสมาชิก",
            style: TextStyle(fontSize: 16),
          ),
      ),

            ],
          ),
        ),
      ),
    );
  }
}
