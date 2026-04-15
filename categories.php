<?php
require_once 'config.php';
$db = getDB();

$rows = $db->query("SELECT c.*, COUNT(p.id) AS product_count
    FROM categories c LEFT JOIN products p ON c.id=p.category_id
    GROUP BY c.id ORDER BY c.name")->fetch_all(MYSQLI_ASSOC);

echo json_encode(['success'=>true,'data'=>$rows]);
$db->close();
