<?php
require_once 'config.php';
$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $id       = $_GET['id']       ?? '';
    $category = $_GET['category'] ?? '';
    $search   = $_GET['search']   ?? '';
    $featured = $_GET['featured'] ?? '';
    $sort     = $_GET['sort']     ?? 'created_at';
    $min      = $_GET['min_price']?? '';
    $max      = $_GET['max_price']?? '';

    // Single product
    if ($id) {
        $stmt = $db->prepare("SELECT p.*, c.name AS category_name, c.icon AS category_icon
            FROM products p LEFT JOIN categories c ON p.category_id=c.id WHERE p.id=?");
        $stmt->bind_param('i', $id);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        echo json_encode(['success'=>true,'data'=>$row]);
        exit;
    }

    $sql = "SELECT p.*, c.name AS category_name, c.icon AS category_icon
            FROM products p LEFT JOIN categories c ON p.category_id=c.id WHERE 1=1";
    $params=[]; $types='';

    if ($search)   { $s="%$search%"; $sql.=" AND (p.name LIKE ? OR p.description LIKE ?)"; $types.='ss'; $params=array_merge($params,[$s,$s]); }
    if ($category) { $sql.=" AND c.slug=?";  $types.='s'; $params[]=$category; }
    if ($featured) { $sql.=" AND p.featured=1"; }
    if ($min!=='') { $sql.=" AND p.price>=?"; $types.='d'; $params[]=(float)$min; }
    if ($max!=='') { $sql.=" AND p.price<=?"; $types.='d'; $params[]=(float)$max; }

    $allowed_sorts = ['price_asc'=>'p.price ASC','price_desc'=>'p.price DESC','rating'=>'p.rating DESC','newest'=>'p.created_at DESC','name'=>'p.name ASC'];
    $order = $allowed_sorts[$sort] ?? 'p.created_at DESC';
    $sql .= " ORDER BY $order";

    $stmt = $db->prepare($sql);
    if ($params) $stmt->bind_param($types,...$params);
    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    echo json_encode(['success'=>true,'data'=>$rows,'count'=>count($rows)]);
}

if ($method === 'POST') {
    $d = json_decode(file_get_contents('php://input'),true);
    $stmt = $db->prepare("INSERT INTO products (name,description,price,original_price,category_id,image_url,stock,badge,featured) VALUES (?,?,?,?,?,?,?,?,?)");
    $stmt->bind_param('ssddisisi',
        $d['name'],$d['description'],$d['price'],$d['original_price'],
        $d['category_id'],$d['image_url'],$d['stock'],$d['badge'],$d['featured']
    );
    if ($stmt->execute()) echo json_encode(['success'=>true,'id'=>$db->insert_id]);
    else echo json_encode(['success'=>false,'message'=>$db->error]);
}

$db->close();
