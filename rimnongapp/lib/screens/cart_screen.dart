import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  final Map<Product, int> cart;
  final int? cusId;

  const CartScreen({Key? key, required this.cart, this.cusId}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  double _discount = 0.0;
  String? _promoMessage;
  String? _promoId;

  @override
  void dispose() {
    _promoController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return widget.cart.keys.fold(0.0, (sum, product) {
      return sum + (product.price * widget.cart[product]!);
    });
  }

  double get _totalPrice {
    return _subtotal - _discount;
  }

  Future<void> _checkPromoCode() async {
    final promoCode = _promoController.text.trim();
    if (promoCode.isEmpty) {
      setState(() {
        _discount = 0.0;
        _promoMessage = null;
        _promoId = null;
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2/api/check_promo.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'promo_name': promoCode}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          _discount = double.parse(data['promo_discount'].toString());
          _promoId = data['promo_id'].toString();
          _promoMessage = 'ใช้โค้ดส่วนลดสำเร็จ! ส่วนลด: ฿${_discount.toStringAsFixed(2)}';
        });
      } else {
        setState(() {
          _discount = 0.0;
          _promoId = null;
          _promoMessage = data['message'] ?? 'โค้ดโปรโมชันไม่ถูกต้อง';
        });
      }
    } catch (e) {
      setState(() {
        _discount = 0.0;
        _promoId = null;
        _promoMessage = 'เกิดข้อผิดพลาดในการตรวจสอบโค้ด';
      });
    }
  }

  // ฟังก์ชันสำหรับเพิ่มหรือลดจำนวนสินค้า
  void _updateQuantity(Product product, int quantity) {
    setState(() {
      if (quantity > 0) {
        widget.cart.update(product, (value) => quantity);
      } else {
        _removeProduct(product);
      }
    });
  }

  // ฟังก์ชันสำหรับลบสินค้าออกจากตะกร้า
  void _removeProduct(Product product) {
    setState(() {
      widget.cart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตะกร้าสินค้า'), backgroundColor: Colors.teal),
      body: widget.cart.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าในตะกร้า'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final product = widget.cart.keys.elementAt(index);
                      final quantity = widget.cart[product]!;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              // ชื่อสินค้า
                              Expanded(
                                child: Text(
                                  product.proName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ปุ่มลดจำนวน
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                                onPressed: () {
                                  if (quantity > 1) {
                                    _updateQuantity(product, quantity - 1);
                                  } else {
                                    _removeProduct(product);
                                  }
                                },
                              ),
                              // จำนวนสินค้า
                              Text(quantity.toString()),
                              // ปุ่มเพิ่มจำนวน
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                                onPressed: () {
                                  _updateQuantity(product, quantity + 1);
                                },
                              ),
                              // ราคารวมต่อรายการ
                              Text('฿${(product.price * quantity).toStringAsFixed(2)}'),
                              // ปุ่มลบสินค้า
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _removeProduct(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _promoController,
                        decoration: InputDecoration(
                          labelText: 'โค้ดโปรโมชัน',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: _checkPromoCode,
                          ),
                        ),
                      ),
                      if (_promoMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _promoMessage!,
                            style: TextStyle(
                              color: _discount > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _remarksController,
                        decoration: const InputDecoration(
                          labelText: 'หมายเหตุ',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ราคาย่อย:', style: TextStyle(fontSize: 16)),
                          Text('฿${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      if (_discount > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ส่วนลด:', style: TextStyle(fontSize: 16, color: Colors.green)),
                            Text('-฿${_discount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                          ],
                        ),
                      const Divider(),
                      Text(
                        'รวมทั้งหมด: ฿${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (widget.cart.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กรุณาเพิ่มสินค้าลงในตะกร้าก่อน')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                orderData: {
                                  'cus_id': widget.cusId ?? 0,
                                  'price_total': _totalPrice,
                                  'remarks': _remarksController.text.trim(),
                                  'order_items': widget.cart.entries.map((entry) {
                                    final product = entry.key;
                                    final quantity = entry.value;
                                    return {
                                      'pro_id': product.proId,
                                      'amount': quantity,
                                      'price_list': product.price,
                                      'pay_total': product.price * quantity,
                                    };
                                  }).toList(),
                                  'promo_id': _promoId,
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('ยืนยันคำสั่งซื้อ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}