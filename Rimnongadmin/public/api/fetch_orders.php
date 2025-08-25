<?php
// fetch_orders.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// เชื่อมต่อฐานข้อมูล
$host = 'localhost';
$dbname = 'rimnong';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
}

// เลือกคำสั่งซื้อที่ยังไม่เสร็จสิ้น (receive_date IS NULL)
// ดึงข้อมูลมาเฉพาะจากตาราง 'order'
$stmt = $pdo->prepare("SELECT
                        o.order_id,
                        o.cus_id,
                        o.order_date,
                        o.price_total,
                        o.receive_date,
                        o.promo_id,
                        o.remarks
                       FROM `order` o
                       WHERE o.receive_date IS NULL
                       ORDER BY o.order_date ASC");
$stmt->execute();
$orders = $stmt->fetchAll(PDO::FETCH_ASSOC);


// ส่วนนี้จะดึงรายละเอียดสินค้าสำหรับแต่ละคำสั่งซื้อ ซึ่งยังคงต้องใช้
foreach ($orders as &$order) {
    // ดึงชื่อลูกค้าแยกต่างหาก
    $stmtCustomer = $pdo->prepare("SELECT fullname FROM customer WHERE cus_id = ?"); // แก้ไขจาก cus_name เป็น fullname
    $stmtCustomer->execute([$order['cus_id']]);
    $customer = $stmtCustomer->fetch(PDO::FETCH_ASSOC);
    $order['cus_name'] = $customer['fullname'] ?? 'ลูกค้าไม่ระบุชื่อ'; // แก้ไขเป็น fullname

    // ดึงรายละเอียดสินค้า
    $stmtDetail = $pdo->prepare("SELECT
                                  od.pro_id,
                                  prod.pro_name,
                                  od.amount,
                                  od.price_list,
                                  od.pay_total
                                 FROM `order_detail` od
                                 JOIN product prod ON od.pro_id = prod.pro_id
                                 WHERE od.order_id = ?");
    $stmtDetail->execute([$order['order_id']]);
    $order['order_details'] = $stmtDetail->fetchAll(PDO::FETCH_ASSOC);

    // ดึงโค้ดโปรโมชันแยกต่างหาก
    if ($order['promo_id'] !== null) {
        $stmtPromo = $pdo->prepare("SELECT promo_code FROM promotion WHERE promo_id = ?");
        $stmtPromo->execute([$order['promo_id']]);
        $promo = $stmtPromo->fetch(PDO::FETCH_ASSOC);
        $order['promo_code'] = $promo['promo_code'] ?? null;
    } else {
        $order['promo_code'] = null;
    }
}

echo json_encode($orders);
?>