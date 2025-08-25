import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const PaymentScreen({super.key, required this.orderData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  File? _slipImage;
  bool _isUploading = false;
  String _promptPayId = '0984873750'; // เลข PromptPay ของร้าน (ใส่ข้อมูลจริง)
  String _bankName = 'ธนาคารกรุงไทย'; // ชื่อธนาคาร
  String _accountName = 'นายพงศกร มณีสาย';

  // ฟังก์ชันคำนวณ CRC (Cyclic Redundancy Check) สำหรับ PromptPay
  int crc16(String data) {
    const int polynomial = 0x1021;
    int crc = 0xFFFF;
    for (int i = 0; i < data.length; i++) {
      crc ^= (data.codeUnitAt(i) << 8);
      for (int j = 0; j < 8; j++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
      }
    }
    return crc & 0xFFFF;
  }

  // สร้างข้อมูล QR Code สำหรับ PromptPay
  String get _promptPayPayload {
    double amount = widget.orderData['price_total'];
    
    // โครงสร้างของ PromptPay QR Code ตามมาตรฐาน EMVCo
    String payload = '000201'; // Payload Format Indicator
    payload += '010212'; // Point of Initiation Method: 12 = Dynamic
    payload += '2937'; // Merchant Account Information: PromptPay
    payload += '0016A000000677010111'; // Application ID
    payload += '01'; // ID Type
    payload += '13' + _promptPayId.padLeft(13, '0'); // PromptPay ID (Phone number)
    payload += '5802TH'; // Country Code: Thailand
    payload += '54' + amount.toStringAsFixed(2).length.toString().padLeft(2, '0') + amount.toStringAsFixed(2); // Amount
    payload += '5303764'; // Currency: THB
    
    // ส่วน CRC จะถูกเพิ่มเป็นส่วนสุดท้าย
    String crcHex = crc16(payload).toRadixString(16).toUpperCase().padLeft(4, '0');
    payload += '6304' + crcHex;

    return payload;
  }

  Future<void> _pickSlipImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _slipImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitOrderWithSlip() async {
    if (_slipImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอัปโหลดรูปภาพสลิปก่อน')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final url = Uri.parse('http://10.0.2.2/api/order.php');

    try {
      var request = http.MultipartRequest('POST', url);
      
      // เพิ่มข้อมูลคำสั่งซื้อ
      // ต้องแปลงข้อมูลอาร์เรย์และตัวเลขให้เป็น JSON string ก่อนส่ง
      request.fields['cus_id'] = widget.orderData['cus_id'].toString();
      request.fields['price_total'] = widget.orderData['price_total'].toString();
      request.fields['remarks'] = widget.orderData['remarks'].toString();
      request.fields['order_items'] = json.encode(widget.orderData['order_items']);
      if (widget.orderData['promo_id'] != null) {
        request.fields['promo_id'] = widget.orderData['promo_id'].toString();
      }

      // เพิ่มรูปภาพสลิป
      request.files.add(
        http.MultipartFile.fromBytes(
          'slip_image',
          _slipImage!.readAsBytesSync(),
          filename: path.basename(_slipImage!.path),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สั่งซื้อสำเร็จ!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'เกิดข้อผิดพลาดในการสั่งซื้อ')),
        );
      }
    } catch (e) {
      print('Error submitting order with slip: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.orderData['price_total'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าชำระเงิน'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'สแกนเพื่อชำระเงินด้วย PromptPay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: QrImageView(
                data: _promptPayPayload,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('ยอดที่ต้องชำระ: ฿${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 8),
                    Text('ชื่อบัญชี: $_accountName', style: const TextStyle(fontSize: 16)),
                    Text('ธนาคาร: $_bankName', style: const TextStyle(fontSize: 16)),
                    Text('พร้อมเพย์: $_promptPayId', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'อัปโหลดสลิปโอนเงิน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _slipImage == null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: _pickSlipImage,
                        icon: const Icon(Icons.add_a_photo, size: 40),
                        label: const Text('เลือกรูปภาพสลิป'),
                      ),
                    ),
                  )
                : Image.file(_slipImage!, height: 200),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickSlipImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('เลือกสลิป'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _submitOrderWithSlip,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('ยืนยันและส่งสลิป'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}