<?php
require_once 'config.php';
$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $d = json_decode(file_get_contents('php://input'),true);
    $ref = 'ORD-' . strtoupper(substr(md5(uniqid()),0,8));
    $items_json = json_encode($d['items']);

    $stmt = $db->prepare("INSERT INTO orders (order_ref,customer_name,customer_email,customer_phone,items,subtotal,shipping,total,payment_method)
        VALUES (?,?,?,?,?,?,?,?,?)");
    $stmt->bind_param('sssssddds',
        $ref, $d['customer_name'], $d['customer_email'], $d['customer_phone'],
        $items_json, $d['subtotal'], $d['shipping'], $d['total'], $d['payment_method']
    );
    if ($stmt->execute()) {
        echo json_encode(['success'=>true,'order_ref'=>$ref]);
    } else {
        echo json_encode(['success'=>false,'message'=>$db->error]);
    }
}

if ($method === 'GET') {
    $rows = $db->query("SELECT * FROM orders ORDER BY created_at DESC LIMIT 50")->fetch_all(MYSQLI_ASSOC);
    foreach ($rows as &$r) $r['items'] = json_decode($r['items'],true);
    echo json_encode(['success'=>true,'data'=>$rows]);
}

$db->close();
