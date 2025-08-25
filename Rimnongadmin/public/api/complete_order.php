<?php
// complete_order.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');

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

// รับข้อมูล JSON
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['order_id']) || !isset($data['em_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
    exit;
}

$orderId = $data['order_id'];
$emId = $data['em_id'];

try {
    // อัปเดต receive_date และ em_id ในตาราง order
    $stmt = $pdo->prepare("UPDATE `order` SET receive_date = NOW(), em_id = ? WHERE order_id = ?");
    $stmt->execute([$emId, $orderId]);

    echo json_encode(['status' => 'success', 'message' => 'Order status updated successfully']);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update order status: ' . $e->getMessage()]);
}
?>
