/*
===============================================================================
                        OLIST E-COMMERCE SQL PROJECT
===============================================================================

Project      : E-Commerce Delivery Performance & Customer Experience Analysis
Database     : olist_ecommerce
Author       : Nandhusri Rajaraman

Description:
This script creates the project database, imports the raw CSV datasets,
verifies the imported data, and prepares the database for further analysis.

Datasets:
• Customers
• Orders
• Order Items
• Payments
• Products
• Reviews
• Sellers
• Geolocation

===============================================================================
*/

-- ============================================================================
-- 1. CREATE DATABASE
-- ============================================================================

CREATE DATABASE olist_ecommerce;

USE olist_ecommerce;

-- ============================================================================
-- 2. ENABLE LOCAL FILE IMPORT
-- ============================================================================

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

-- ============================================================================
-- 3. IMPORT ORDERS DATASET
-- ============================================================================

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

DESCRIBE orders;

LOAD DATA LOCAL INFILE
'E:/Data analytics/Data Analytics portfolio/E-commerce Delivery Performance & Customer Experience Analysis/dataset/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @purchase,
    @approved,
    @carrier,
    @delivered,
    @estimated
)
SET
    order_purchase_timestamp = NULLIF(TRIM(@purchase), ''),
    order_approved_at = NULLIF(TRIM(@approved), ''),
    order_delivered_carrier_date = NULLIF(TRIM(@carrier), ''),
    order_delivered_customer_date = NULLIF(TRIM(@delivered), ''),
    order_estimated_delivery_date = NULLIF(TRIM(@estimated), '');
    
-- ============================================================================
-- 4. IMPORT REVIEWS DATASET
-- ============================================================================

DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews
(
    review_id TEXT,
    order_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

DESCRIBE reviews;

LOAD DATA LOCAL INFILE
'E:/Data analytics/Data Analytics portfolio/E-commerce Delivery Performance & Customer Experience Analysis/dataset/olist_order_reviews_dataset.csv'
INTO TABLE reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @creation_date,
    @answer_timestamp
)
SET
    review_creation_date = NULLIF(TRIM(@creation_date), ''),
    review_answer_timestamp = NULLIF(TRIM(@answer_timestamp), '');
    
-- ============================================================================
-- 5. IMPORT GEOLOCATION DATASET
-- ============================================================================

DROP TABLE IF EXISTS geolocation;

CREATE TABLE geolocation 
(
    geolocation_zip_code_prefix TEXT,
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city TEXT,
    geolocation_state TEXT
);

DESCRIBE geolocation;

LOAD DATA LOCAL INFILE
'E:/Data analytics/Data Analytics portfolio/E-commerce Delivery Performance & Customer Experience Analysis/dataset/olist_geolocation_dataset.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
);

-- ============================================================================
-- 6. VERIFY TABLES
-- ============================================================================

SHOW TABLES;

DESCRIBE orders;

DESCRIBE reviews;

DESCRIBE geolocation;

-- ============================================================================
-- 7. VERIFY ROW COUNTS
-- ============================================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'reviews', COUNT(*)
FROM reviews

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM geolocation;

/*
===============================================================================
Database setup completed successfully.

The database is now ready for:

1. Data Quality Assessment
2. Exploratory Data Analysis
3. Business Analysis
===============================================================================
*/