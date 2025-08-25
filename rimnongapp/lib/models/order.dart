import 'dart:convert';

// Class สำหรับเก็บข้อมูลสินค้าใน Order Detail
class OrderDetail {
  final String proId;
  final String proName;
  final int amount;
  final double priceList;
  final double payTotal;

  OrderDetail({
    required this.proId,
    required this.proName,
    required this.amount,
    required this.priceList,
    required this.payTotal,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      proId: json['pro_id'].toString(), // แก้ไข: แปลงค่าเป็น String
      proName: json['pro_name'],
      amount: int.parse(json['amount'].toString()),
      priceList: double.parse(json['price_list'].toString()),
      payTotal: double.parse(json['pay_total'].toString()),
    );
  }
}

// Class สำหรับเก็บข้อมูลคำสั่งซื้อหลัก
class Order {
  final int orderId;
  final String customerName;
  final String orderDate;
  final double totalPrice;
  final String? promoCode;
  final String? remarks;
  final String? slipPath;
  final List<OrderDetail> orderDetails;
  bool isCompleted;

  Order({
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.totalPrice,
    this.promoCode,
    this.remarks,
    this.slipPath,
    required this.orderDetails,
    this.isCompleted = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<dynamic> details = json['order_details'] ?? [];
    return Order(
      orderId: int.parse(json['order_id'].toString()),
      customerName: json['cus_name'] ?? 'ลูกค้าไม่ระบุชื่อ',
      orderDate: json['order_date'],
      totalPrice: double.parse(json['price_total'].toString()),
      promoCode: json['promo_code'],
      remarks: json['remarks'],
      slipPath: json['slip_path'],
      orderDetails: details.map((item) => OrderDetail.fromJson(item)).toList(),
      isCompleted: json['receive_date'] != null,
    );
  }
}
