-- Run once to set up ecommerce database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    icon VARCHAR(10) DEFAULT '📦'
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2) DEFAULT NULL,
    category_id INT,
    image_url VARCHAR(255),
    stock INT DEFAULT 0,
    rating DECIMAL(3,1) DEFAULT 0,
    reviews_count INT DEFAULT 0,
    badge VARCHAR(30) DEFAULT NULL,
    featured TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_ref VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20),
    items JSON NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    shipping DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    payment_method ENUM('mpesa','card','cash') DEFAULT 'mpesa',
    status ENUM('pending','confirmed','shipped','delivered') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
INSERT IGNORE INTO categories (name, slug, icon) VALUES
('Electronics',    'electronics',  '💻'),
('Fashion',        'fashion',      '👗'),
('Home & Living',  'home',         '🏠'),
('Sports',         'sports',       '⚽'),
('Beauty',         'beauty',       '💄'),
('Books',          'books',        '📚');

-- Products
INSERT IGNORE INTO products (name, description, price, original_price, category_id, image_url, stock, rating, reviews_count, badge, featured) VALUES
-- Electronics
('Wireless Noise-Cancelling Headphones','Premium over-ear headphones with 40hr battery life, active noise cancellation, and foldable design.',8500,12000,1,'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80',45,4.7,312,'Best Seller',1),
('Smart Watch Series 5','Health tracking, GPS, water-resistant to 50m. Compatible with Android & iOS.',14500,18000,1,'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80',28,4.5,198,'Sale',1),
('Mechanical Keyboard TKL','Tenkeyless RGB mechanical keyboard, blue switches, aluminium frame.',6200,NULL,1,'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&q=80',60,4.6,87,NULL,0),
('USB-C 65W Fast Charger','GaN technology, charges laptop + phone simultaneously. Compact design.',2100,3500,1,'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=400&q=80',120,4.4,156,'Hot',0),
('Portable Bluetooth Speaker','360° surround sound, 24hr battery, IPX7 waterproof. Ideal for outdoors.',4800,6500,1,'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&q=80',35,4.3,201,NULL,1),

-- Fashion
('Classic Leather Sneakers','Genuine leather upper, cushioned insole, available in 6 colours.',4500,NULL,2,'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',80,4.6,445,'Trending',1),
('Oversized Cotton Hoodie','100% organic cotton, preshrunk, unisex sizing S–XXL.',2800,4200,2,'https://images.unsplash.com/photo-1556821840-3a63f15732ce?w=400&q=80',200,4.5,290,'Sale',0),
('Slim Fit Chino Trousers','Stretch-cotton blend, 4 colours, machine washable.',2200,NULL,2,'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400&q=80',150,4.2,178,NULL,0),

-- Home
('Ceramic Pour-Over Coffee Set','Hand-thrown ceramic dripper + carafe, filters included. For the coffee lover.',3600,NULL,3,'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&q=80',40,4.8,132,'New',1),
('Bamboo Desk Organiser','Eco-friendly, 6 compartments, natural finish.',1200,1800,3,'https://images.unsplash.com/photo-1593642532559-0c6d3fc62b89?w=400&q=80',90,4.4,67,'Sale',0),
('Linen Throw Blanket 150×200cm','Stonewashed linen, breathable, 4 neutral tones.',3200,NULL,3,'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80',55,4.7,88,NULL,0),

-- Sports
('Yoga Mat Pro 6mm','Non-slip TPE material, alignment lines, carry strap included.',2500,3200,4,'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=400&q=80',70,4.5,223,'Best Seller',1),
('Adjustable Dumbbell Set 5–25kg','Space-saving dial mechanism, replaces 15 pairs. Cast iron plates.',18500,24000,4,'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&q=80',15,4.6,95,NULL,1),

-- Beauty
('Vitamin C Serum 30ml','20% stabilised ascorbic acid, hyaluronic acid, paraben-free.',1800,2800,5,'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab12?w=400&q=80',200,4.7,512,'Hot',1),
('Matte Lip Collection (6 shades)','Long-wear formula, 6-piece set, vegan & cruelty-free.',1500,NULL,5,'https://images.unsplash.com/photo-1586495777744-4e6232bf2176?w=400&q=80',300,4.5,340,'New',0),

-- Books
('Clean Code – Robert C. Martin','Timeless guide to writing readable, maintainable software.',1900,NULL,6,'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80',500,4.8,1204,'Classic',1),
('Atomic Habits – James Clear','Proven framework for building good habits and breaking bad ones.',1700,2200,6,'https://images.unsplash.com/photo-1589998059171-988d887df646?w=400&q=80',400,4.9,2310,'Best Seller',1);
