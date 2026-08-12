/*
=========================================================
Project: E-commerce Delivery Performance &
         Customer Experience Analysis

File: 02_data_quality.sql

Purpose:
Validate the imported Olist dataset before performing
business analysis.

Checks performed:
1. Table row counts
2. Primary identifier uniqueness
3. Missing values
4. Duplicate records
5. Date ranges
6. Relationships between tables
=========================================================
*/

USE olist_ecommerce;


-- =====================================================
-- 1. TABLE ROW COUNTS
-- =====================================================

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
Observation:
All required tables were successfully loaded.
Row counts were checked before beginning analysis.
*/


-- =====================================================
-- 2. CUSTOMER IDENTIFIER UNIQUENESS
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;


/*
Purpose:
Check the difference between customer_id and
customer_unique_id.
customer_id identifies the customer record associated
with an order, while customer_unique_id can be used to
identify customers across multiple orders.

Finding:
The customers table contains 99,441 customer records with
99,441 unique customer_id values, confirming that customer_id
is unique within this table.
However, only 96,096 distinct customer_unique_id values exist,
indicating that some customers placed multiple orders.
For customer-level analysis and repeat purchase analysis,
customer_unique_id should therefore be used.
*/


-- =====================================================
-- 3. ORDER IDENTIFIER UNIQUENESS
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM orders;


/*
Purpose:
Verify whether order_id uniquely identifies each order
and understand the relationship between orders and
customer records.

Finding:
The orders table contains 99,441 rows and 99,441 distinct
order_id values, confirming that order_id uniquely identifies
each order.
There are also 99,441 distinct customer_id values, showing
that each order is associated with a unique customer record.
*/

-- =====================================================
-- 4. MISSING VALUE CHECKS
-- =====================================================

-- Check missing timestamps in the orders table

SELECT 
	 COUNT(*) as total_orders,
     
     SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
     SUM(order_approved_at IS NULL) AS missing_approved_date,
     SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
     SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date,
     SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_date
FROM orders;

-- Investigate order status for orders with missing delivery dates

SELECT 
     order_status,
     COUNT(*) as order_count
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY order_count DESC;

/*
Finding:
2,965 orders have no customer delivery timestamp.

Most missing delivery dates correspond to orders that were not
completed, including shipped, canceled, unavailable, processing,
and invoiced orders.

Only 8 orders have order_status = 'delivered' while the
order_delivered_customer_date is NULL. These represent a small
data-quality inconsistency.

For delivery-performance analysis, only delivered orders with
a valid delivery timestamp will be included.
*/

-- Investigate order status for orders with missing approval dates

SELECT 
     order_status,
     COUNT(*) AS order_count
FROM orders
WHERE order_approved_at IS NULL
GROUP BY order_status
ORDER BY order_count DESC;

/*
Finding:
160 orders have missing approval timestamps.

Most are explained by order status:
- 141 canceled
- 5 created

However, 14 delivered orders also have a missing approval
timestamp, indicating a small data-quality inconsistency.

These records will be retained because order_approved_at is
not required for the primary delivery-performance metrics.
*/


-- Investigate order status for orders with missing carrier dates

SELECT 
     order_status,
     COUNT(*) AS order_count
FROM orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status
ORDER BY order_count DESC;

/*
Finding:
1,783 orders have missing carrier delivery timestamps.

Most missing values occur in orders that were canceled,
unavailable, processing, invoiced, created, or approved,
which is consistent with orders that had not reached the
carrier-shipment stage.

Only 2 delivered orders have a missing carrier timestamp,
representing a minor data-quality inconsistency.

For delivery-performance analysis, records requiring carrier
timestamps will be filtered to valid non-null values when
that timestamp is specifically needed.
*/


-- =====================================================
-- 5. DUPLICATE CHECKS
-- =====================================================

-- Check for duplicate order IDs

SELECT 
      order_id,
      COUNT(*) AS occurrence_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate order_id values were found.

Each of the 99,441 orders has a unique order_id,
confirming that order_id can be used as the unique
identifier for the orders table.
*/


-- Check for duplicate order-item records

SELECT 
     order_id,
     order_item_id,
     COUNT(*) AS occurrence_count
FROM order_items
GROUP BY 
       order_id,
       order_item_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate order-item records were found.

The combination of order_id and order_item_id uniquely
identifies each item within an order.
*/


-- Check for duplicate payment records

SELECT
     order_id,
     payment_sequential,
     COUNT(*) AS occurrence_count
FROM payments
GROUP BY 
       order_id,
       payment_sequential
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate payment records were found.

The combination of order_id and payment_sequential
uniquely identifies each payment transaction.

Multiple payment records for the same order are valid
because an order may contain multiple payment sequences.
*/


-- Check for duplicate product IDs

SELECT 
	  product_id,
      COUNT(*) AS occurrence_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate product_id values were found.

Each product_id uniquely identifies a product in the
products table.
*/


-- Check for duplicate seller IDs

SELECT
     seller_id,
     COUNT(*) AS occurrence_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate seller_id values were found.

Each seller_id uniquely identifies a seller in the
sellers table.
*/


-- Check for duplicate customer IDs

SELECT
	 customer_id,
     COUNT(*) AS occurrence_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate customer_id values were found.

Each customer_id uniquely identifies a customer record
in the customers table.

customer_unique_id is intentionally not treated as unique
because the same real customer may appear across multiple orders.
*/


-- Check for duplicate review IDs

SELECT
     review_id,
     COUNT(*) AS occurrence_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT
    review_id,
    COUNT(*) AS row_count,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

/*
Finding:
Duplicate review_id values were found in the reviews table.

Further investigation showed that repeated review_id values
are associated with different order_id values. Therefore,
review_id alone cannot be treated as a unique identifier
for individual review records.

These records were retained because repeated review IDs
do not by themselves indicate duplicate rows.
*/


-- Check for duplicate review-order records

SELECT 
     order_id,
     review_id,
     COUNT(*) AS occurrence_count
FROM reviews
GROUP BY 
       review_id,
       order_id
HAVING COUNT(*) > 1;

/*
Finding:
No duplicate review-order records were found.

Although review_id alone is not unique, the combination of
review_id and order_id uniquely identifies each record in the
reviews table.

Therefore, no review records were removed during the
duplicate-checking process.
*/


-- =====================================================
-- 6. REFERENTIAL INTEGRITY CHECKS
-- =====================================================

-- Check for orders referencing non-existent customers

SELECT
     COUNT(*) AS orphan_count
FROM orders AS o
LEFT JOIN customers AS c
     ON o.customer_id=c.customer_id
WHERE c.customer_id IS NULL;

/*
Finding:
No orphan customer references were found.

Every customer_id in the orders table has a matching
customer_id in the customers table, confirming referential
integrity between orders and customers.
*/


-- Check for order items referencing non-existent orders

SELECT
     COUNT(*) AS orphan_count
FROM order_items AS oi
LEFT JOIN orders AS o
     on oi.order_id=o.order_id
WHERE o.order_id IS NULL;

/*
Finding:
No orphan order-item records were found.

Every order_id in the order_items table has a matching
order_id in the orders table, confirming referential
integrity between order_items and orders.
*/


-- Check for order items referencing non-existent products

SELECT 
     COUNT(*) AS orphan_count
FROM order_items AS oi
LEFT JOIN products AS p
     on oi.product_id=p.product_id
WHERE p.product_id IS NULL;

-- Investigate missing product references

SELECT
    COUNT(*) AS orphan_item_rows,
    COUNT(DISTINCT oi.product_id) AS missing_product_ids,
    COUNT(DISTINCT oi.order_id) AS affected_orders
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

/*
Finding:
1,604 order-item rows reference product_id values that do not
exist in the products table.

These rows represent 611 distinct missing product IDs and affect
1,452 distinct orders.

The affected order-item records were retained because they still
contain valid transactional information such as order_id, seller_id,
price, and freight_value.

However, product-level attributes will be unavailable for these
records when joining order_items to products. Analyses requiring
product metadata will therefore exclude unmatched products or treat
them separately.

No records were deleted or modified.
*/


-- Check for order items referencing non-existent sellers

SELECT
     COUNT(*) AS orphan_count
FROM order_items AS oi
LEFT JOIN sellers AS s
     ON oi.seller_id=s.seller_id
WHERE s.seller_id IS NULL;

/*
Finding:

No orphan seller references were found.

Every seller_id in the order_items table has a matching
seller_id in the sellers table, confirming referential
integrity between order_items and sellers.
*/


-- Check for payments referencing non-existent orders

SELECT 
     COUNT(*) AS orphan_count
FROM payments as p
LEFT JOIN orders as o
     ON p.order_id=o.order_id
WHERE o.order_id IS NULL;

/*
Finding:

No orphan payment references were found.

Every order_id in the payments table has a matching
order_id in the orders table, confirming referential
integrity between payments and orders.
*/


-- Check for reviews referencing non-existent orders

SELECT 
     COUNT(*) AS orphan_count
FROM reviews as r
LEFT JOIN orders as o
     ON r.order_id=o.order_id
WHERE o.order_id IS NULL;

/*
Finding:

No orphan review references were found.

Every order_id in the reviews table has a matching
order_id in the orders table, confirming referential
integrity between reviews and orders.
*/


-- =====================================================
-- 7. BUSINESS RULE VALIDATION
-- =====================================================

-- Check for invalid product prices

SELECT 
      COUNT(*) AS invalid_price_records
FROM order_items
WHERE price <=0;

/*
Finding:

No invalid product prices were found.

All order items have positive price values,
indicating valid sales transactions.
*/


-- Check for invalid freight charges

SELECT 
     COUNT(*) AS invalid_freight_charges
FROM order_items
WHERE freight_value < 0;

/*
Finding:

No negative freight charges were found.
All freight values are valid and greater than
or equal to zero.
*/


-- Check for invalid payment values

SELECT 
     COUNT(*) AS invalid_payment_records
FROM payments
WHERE payment_value <= 0;


SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM payments
WHERE payment_value <= 0
ORDER BY payment_value;

/*
Finding:

Nine payment records have a payment_value of zero.
No negative payment values were found.
These transactions use payment types such as
'voucher' and 'not_defined', suggesting they
represent promotional, voucher-based, or special
payment scenarios rather than invalid data.
The records were retained because zero-value
payments do not necessarily indicate data errors.
*/


-- Check review score range

SELECT 
     COUNT(*) AS invalid_review_score 
FROM reviews
WHERE review_score NOT BETWEEN 1 AND 5;

/*
Finding:

All review scores fall within the expected
range of 1 to 5.
No invalid review ratings were found.
*/


-- Check if order delivered before purchase

SELECT 
     COUNT(*) AS invalid_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;
  
/*
Finding:

No orders were found where the customer delivery
date occurred before the purchase timestamp.
The chronological sequence of purchase and delivery
is valid for all delivered orders.
*/


-- Check if order approved before purchase

SELECT 
     COUNT(*) AS invalid_orders
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;

/*
Finding:

No orders were approved before they were purchased.
Every approval timestamp occurs on or after the
purchase timestamp, confirming a valid order
processing sequence.
*/


-- Check if carrier picked up the order before purchase

SELECT
     COUNT(*) AS invalid_orders
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;
  
/*
Finding:

1,359 orders have carrier pickup timestamps that occur
before the recorded approval timestamp.

These records were retained because they likely reflect
timing differences between logistics events and payment
approval updates rather than data corruption.

No records were modified or removed.
*/


-- Check if order delivered to customer before carrier pickup

SELECT 
     COUNT(*) AS invalid_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;
  
/*
Finding:

23 orders have a customer delivery timestamp earlier than
the recorded carrier pickup timestamp.

Given the extremely small number of affected records
(~0.02% of all orders), these are most likely caused by
timestamp recording inconsistencies rather than actual
business process errors.

These records were retained and flagged for awareness.
*/


-- Check Estimated Delivery Before Purchase

SELECT 
     COUNT(*) AS invalid_orders
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date < order_purchase_timestamp;
  
/*
Finding:

No orders have an estimated delivery date that occurs
before the purchase timestamp.

This confirms that estimated delivery dates are
chronologically valid across the dataset.
*/


/*
=========================================================
DATA QUALITY SUMMARY
=========================================================

Tables Checked          : 7
Duplicate Checks        : Passed
Referential Integrity   : Passed
Missing Value Analysis  : Completed
Business Rule Checks    : Completed

Known Issues:

• 611 missing product IDs
• 1,604 order items affected
• 9 zero-value voucher payments
• 1,359 carrier timestamp anomalies
• 23 delivery timestamp anomalies

Conclusion:

The dataset is suitable for exploratory analysis and
dashboard development. Minor issues have been documented
and retained because they do not materially affect the
planned business analysis.
=========================================================
*/
