/*
=========================================================
Project : E-commerce Delivery Performance &
          Customer Experience Analysis

File    : 03_exploratory_data_analysis.sql

Purpose :
Perform exploratory data analysis (EDA) to generate
business insights from the validated Olist dataset.

Author  : Nandhusri Rajaraman
=========================================================
*/

USE olist_ecommerce;

-- =====================================================
-- 1. OVERALL BUSINESS OVERVIEW
-- =====================================================

-- 1. Total Orders

SELECT 
     COUNT(*) AS total_orders
FROM orders;

/*
Finding:

The dataset contains 99,441 customer orders.

This KPI represents the overall transaction volume
and serves as the baseline for subsequent analysis.
*/

-- 2. Total Customers

SELECT
     COUNT(DISTINCT customer_unique_id) as total_customers
FROM customers;

/*
Finding:

The marketplace served 96,096 unique customers.

customer_unique_id is used because a single customer
may place multiple orders, resulting in multiple
customer_id values.
*/

-- 3. Total Sellers

SELECT 
     COUNT(*) AS total_sellers
FROM sellers;

/*
Finding:

The marketplace consists of 3,095 active sellers.

This KPI reflects the size of the seller network
participating in the e-commerce platform.
*/

-- 4. Total Revenue

SELECT
     ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;

/*
Finding:

The platform generated total revenue of
16,008,872.12.

Revenue is calculated using the payment_value
recorded for each payment transaction.
*/

-- 5. Average order value

SELECT
    ROUND(AVG(order_total),2) AS average_order_value
FROM
(
    SELECT
        order_id,
        SUM(payment_value) AS order_total
    FROM payments
    GROUP BY order_id
) t;

/*
Finding:

The average customer order value is 160.99.

Order value is calculated by summing all
payment transactions belonging to the same order.
*/

-- 6. Average products per order

SELECT 
     ROUND(AVG(item_count),2) AS average_products_per_order
FROM 
    (SELECT 
         order_id, 
		 COUNT(*) AS item_count
     FROM order_items
     GROUP BY order_id) AS items;
     
/*
Finding:

Customers purchase an average of 1.14 products
per order.

This indicates that most orders consist of
a single product, with relatively few
multi-item purchases.
*/

/*
=========================================================
SECTION SUMMARY

• Total Orders          : 99,441
• Unique Customers      : 96,096
• Total Sellers         : 3,095
• Total Revenue         : 16,008,872.12
• Average Order Value   : 160.99
• Avg Products / Order  : 1.14

Overall Observation:

The marketplace serves a large customer base
through more than 3,000 sellers.

Customers typically purchase one product per
order, providing a baseline for later analyses
on customer behavior, revenue, and delivery
performance.

=========================================================
*/

-- =====================================================
-- 2. SALES TREND ANALYSIS
-- =====================================================

-- 2.1 Monthly Order Trend

SELECT 
      date_format(order_purchase_timestamp,"%Y-%m") as months,
      COUNT(*) AS number_of_orders
FROM orders
GROUP BY months
ORDER BY months;

/*
Finding:

Monthly order volume increased steadily throughout 2017,
reaching its highest point in November 2017 with 7,544 orders.

Order volume remained relatively stable during 2018 before
dropping sharply in September and October 2018.

The decline is likely due to the dataset ending during this
period rather than an actual decrease in customer demand.

The November 2017 peak may be associated with seasonal
shopping events such as Black Friday or other promotional
campaigns.
*/

-- 2.2 Monthly Revenue Trend

SELECT 
      DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') as months,
      ROUND(SUM(payment_value),2) as revenue
FROM orders as o 
JOIN payments as p 
ON o.order_id=p.order_id
GROUP BY months
ORDER By months;

/*
Finding:

Monthly revenue generally increased from early 2017 and reached
its highest value in November 2017.

Although revenue fluctuated afterward, it remained relatively high
through the first half of 2018.

Revenue drops sharply in September and October 2018 because the
dataset contains only partial data for these months, not because
of an actual decline in business performance.

Overall, the revenue trend closely follows the monthly order trend,
suggesting that higher order volumes contributed to higher revenue.
*/
     
-- 2.3 Customer Growth

SELECT 
      DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS months,
      COUNT(DISTINCT c.customer_unique_id)  AS total_customers
FROM orders as o
JOIN customers as c
ON o.customer_id=c.customer_id
GROUP BY months
ORDER BY months;
     
/*
Finding:

The number of unique customers increased steadily from January 2017,
indicating continuous customer acquisition and marketplace growth.

Customer growth peaked in November 2017 with 7,430 unique customers,
which aligns with the highest monthly order volume and revenue,
suggesting strong seasonal demand.

Although there were minor fluctuations during 2018, the platform
maintained a consistently high customer base.

The sharp decline in September and October 2018 is due to the dataset
containing only partial data for those months rather than an actual
drop in customer activity.
*/

-- 2.4 Order Status Distribution

SELECT
      order_status,
      COUNT(order_id) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

/*
Finding:

The vast majority of orders (96,478) were successfully delivered,
indicating an efficient order fulfillment process.

Only a small number of orders were cancelled (625) or marked
as unavailable (609), suggesting relatively few fulfillment issues.

Very few orders remained in intermediate stages such as
created, approved, processing, invoiced, or shipped,
showing that most orders eventually progressed to delivery.

Overall, the marketplace demonstrates a high delivery completion rate
and a stable operational workflow.
*/

-- 2.5 Top States by Number of Orders

SELECT
     c.customer_state,
     COUNT(o.order_id) as order_count
FROM customers as c
JOIN orders as o
ON c.customer_id=o.customer_id
GROUP BY c.customer_state
ORDER BY order_count DESC;

/*
Finding:

São Paulo (SP) is the largest market with 41,746 orders,
accounting for a significantly higher order volume than any
other state.

Rio de Janeiro (RJ) and Minas Gerais (MG) are the second and
third largest markets with 12,852 and 11,635 orders respectively.

The top three states contribute a substantial portion of the
overall marketplace demand, indicating that customer activity
is concentrated in Brazil's major economic regions.

Smaller states such as Roraima (RR), Amapá (AP), and Acre (AC)
recorded the fewest orders, suggesting lower market penetration
or population density.
*/


-- 2.6 Top Product Categories by Revenue

SELECT
     p.product_category_name,
     ROUND(SUM(oi.price),2) AS revenue
FROM products AS p
JOIN order_items AS oi
ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

/*
Finding:

The 'beleza_saude' (Beauty & Health) category generated the highest revenue,
making it the top-performing product category in the marketplace.

The 'seguros_e_servicos' (Insurance & Services) category generated the lowest revenue, 
indicating very low customer demand.

Revenue is concentrated among a few high-performing product categories, 
while many other categories contribute relatively less to the overall revenue.

Business Insight:

The company should continue investing in high-performing categories through inventory planning and targeted marketing, 
while evaluating low-performing categories for improvement, promotion, or possible discontinuation.
*/

-- 2.7 Most Purchased Product Categories

SELECT 
	 p.product_category_name, 
     COUNT(oi.order_item_id) AS order_count
FROM order_items as oi
JOIN products as p
ON oi.product_id=p.product_id
GROUP BY p.product_category_name
ORDER BY order_count DESC;

/*
Finding:

The 'cama_mesa_banho' (Bed, Bath & Table) category is the most
purchased product category with 11,115 items sold.

'Beleza_saude' (Beauty & Health) and 'esporte_lazer'
(Sports & Leisure) are the second and third most purchased
categories with 9,670 and 8,641 items sold respectively.

The 'seguros_e_servicos' (Insurance & Services) category
recorded the fewest purchases with only 2 items sold.

Most customer purchases are concentrated in a small number of
popular product categories, while many other categories have
relatively low purchase volumes.
*/

-- 2.8 Average Delivery Time

SELECT 
      ROUND(AVG(datediff(order_delivered_customer_date,order_purchase_timestamp)),2) AS average_delivery_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*
Finding:

The average delivery time is approximately 12.5 days
from the order purchase date to the customer delivery date.

This indicates that customers typically receive their
orders within nearly two weeks after placing an order.

The calculation considers only delivered orders,
excluding orders that were cancelled or never delivered.
*/

-- 2.9 On-Time Delivery Performance

SELECT 
     ROUND((
           SUM(
               CASE
                   WHEN order_delivered_customer_date <= order_estimated_delivery_date 
                   THEN 1
                   ELSE 0
				END
                )*100
			)/COUNT(*),
            2)
            AS on_time_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*
Finding:

Approximately 91.89% of delivered orders were delivered
on or before the estimated delivery date.

This indicates that the marketplace has a strong delivery
performance, with the majority of orders meeting customer
delivery expectations.

Only about 8.11% of delivered orders were delivered later
than the estimated delivery date, suggesting relatively
few delivery delays.
*/


-- 2.10 Average Customer Review Score

SELECT
     ROUND(AVG(review_score),2) as average_review_score
FROM reviews;

/*
Finding:

The average customer review score is 4.09 out of 5,
indicating that customers are generally satisfied with
their overall shopping experience.

An average rating above 4 suggests that most customers
had positive experiences with product quality, delivery,
and overall service.

This reflects a strong level of customer satisfaction
across the marketplace.
*/


-- 2.11 Review Score Distribution

SELECT
      review_score,
      COUNT(review_score) as number_of_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;

/*
Finding:

5-star reviews are the most common, with 57,327 reviews,
followed by 4-star reviews with 19,142 ratings.

Only a relatively small number of customers gave
2-star (3,151) and 3-star (8,179) ratings.

Although 1-star reviews account for 11,424 ratings,
they are significantly fewer than the number of
5-star reviews.

The review distribution is heavily skewed toward
higher ratings, indicating that most customers
had a positive shopping experience.
*/


-- 2.12 Payment Method Distribution

SELECT 
      payment_type,
      COUNT(payment_type) as number_of_transactions
FROM payments
GROUP BY payment_type
ORDER BY number_of_transactions DESC;

/*
Finding:

Credit cards are the most preferred payment method,
accounting for 76,795 transactions, making them the
dominant choice among customers.

'Boleto' is the second most frequently used payment
method with 19,784 transactions, followed by vouchers
with 5,775 transactions.

Debit card payments are relatively uncommon, with only
1,529 transactions, while the 'not_defined' payment
method was used only 3 times.

The payment distribution indicates a strong customer
preference for credit card transactions over other
available payment methods.
*/


-- 2.13 Payment Installment Analysis

SELECT
      payment_installments,
      COUNT(payment_installments) AS transactions
FROM payments
GROUP BY payment_installments
ORDER BY transactions DESC;

/*
Finding:

Single-installment payments are the most preferred payment option,
with 52,546 transactions, indicating that most customers prefer
paying the full amount at once.

Two-installment (12,413) and three-installment (10,461) payments
are the next most popular choices, followed by four installments
with 7,098 transactions.

The number of transactions generally decreases as the number of
installments increases, showing that customers are less likely to
choose long-term installment plans.

Very high installment options such as 21, 22, 23, and 24
installments were rarely used, with only a handful of transactions,
indicating minimal demand for extended payment periods.
*/


-- 2.14 Top Sellers by Revenue

SELECT
      s.seller_id,
	  ROUND(SUM(oi.price),2) AS total_revenue
FROM sellers AS s
JOIN order_items AS oi
ON s.seller_id=oi.seller_id
GROUP BY seller_id
ORDER BY total_revenue DESC;

/*
Finding:

Seller '4869f7a5dfa277a7dca6462dcf3b52b2' generated the highest
revenue of approximately 229,472.63, making it the top-performing
seller on the marketplace.

The second and third highest revenue-generating sellers earned
approximately 222,776.05 and 200,472.92 respectively, indicating
that a small group of sellers contributes significantly to overall
marketplace revenue.

The top 10 sellers each generated more than 138,000 in revenue,
highlighting a concentration of sales among a limited number of
high-performing sellers.

Identifying these top sellers can help the business strengthen
seller relationships, improve retention strategies, and understand
the practices that drive higher sales performance.
*/


-- 2.15 Revenue by State

SELECT
      c.customer_state,
      ROUND(SUM(oi.price),2) AS total_revenue
FROM orders AS o
JOIN customers AS c
ON o.customer_id=c.customer_id
JOIN order_items AS oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

/*
Finding:

São Paulo (SP) generated the highest revenue of approximately
5,202,955.05, making it the most valuable customer market
for the marketplace.

Rio de Janeiro (RJ) and Minas Gerais (MG) ranked second and
third with revenues of approximately 1,824,092.67 and
1,585,308.03 respectively.

The top three states contribute a significant share of the
marketplace's total revenue, indicating that sales are highly
concentrated in Brazil's largest economic regions.

States such as Goiás (GO), Distrito Federal (DF), and Bahia (BA)
generated comparatively lower revenue than the leading states,
suggesting opportunities for business expansion and increased
market penetration in these regions.
*/


-- 2.16 Top Customer Cities by Number of Orders

SELECT
     c.customer_city,
     COUNT(order_id) AS order_count
FROM customers AS c
JOIN orders AS o
ON c.customer_id=o.customer_id
GROUP BY c.customer_city
ORDER BY order_count DESC;

/*
Finding:

São Paulo is the leading customer city with 15,540 orders,
making it the largest contributor to marketplace demand.

Rio de Janeiro and Belo Horizonte ranked second and third,
recording 6,882 and 2,773 orders respectively.

The top customer cities are major metropolitan areas, indicating
that customer demand is concentrated in highly populated urban
regions of Brazil.

Cities such as Curitiba, Campinas, Porto Alegre, Salvador,
and Guarulhos also contribute significantly to total orders,
showing strong marketplace adoption across multiple large cities.
*/


-- 2.17 Average Freight Cost

SELECT
      ROUND(AVG(freight_value),2) AS average_freight_cost
FROM order_items;

/*
Finding:

The average freight (shipping) cost per order item is approximately
19.99, indicating that customers typically pay around 20 currency
units for product delivery.

This suggests that shipping costs remain relatively moderate across
the marketplace, helping maintain affordable delivery charges for
customers.

A consistent average freight cost also indicates a balanced shipping
pricing strategy across different products and regions, although
individual freight charges may vary depending on product size,
weight, and delivery distance.
*/


-- 2.18 Product Categories by Average Freight Cost

SELECT
     p.product_category_name,
     ROUND(AVG(oi.freight_value),2) AS average_freight_value
FROM products AS p
JOIN order_items AS oi
ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY average_freight_value DESC;

/*
Finding:

The 'pcs' product category recorded the highest average freight
cost at approximately 48.45, making it the most expensive
category to ship.

Other categories with high average shipping costs include
'eletrodomesticos_2', 'moveis_colchao_e_estofado',
'moveis_cozinha_area_de_servico_jantar_e_jardim', and
'moveis_quarto', all with average freight costs exceeding 40.

Most of the highest freight cost categories consist of furniture,
large household items, and bulky products, indicating that
shipping expenses are strongly influenced by product size,
weight, and handling requirements.

Understanding freight costs by product category can help the
business optimize shipping strategies, negotiate logistics costs,
and improve pricing decisions for high-cost products.
*/


-- 2.19 Top Sellers by Number of Orders

SELECT
      seller_id,
      COUNT(order_id) AS order_count
FROM order_items
GROUP BY seller_id
ORDER BY order_count DESC;


/*
Finding:

The most active seller fulfilled 2,033 order items, making them
the highest-volume seller on the marketplace.

Several other sellers also processed a large number of orders,
with the top five sellers each handling more than 1,700 order items,
indicating a group of highly active merchants driving marketplace sales.

Although a few sellers process very high order volumes, the marketplace
contains a much larger number of sellers with significantly fewer orders,
suggesting that order activity is concentrated among a relatively small
portion of sellers.

Identifying these top-performing sellers can help the business strengthen
seller relationships, improve inventory planning, and develop incentive
programs for high-performing merchants.
*/

-- 2.20 Top Product Categories by Average Review Score

SELECT 
      p.product_category_name ,
      ROUND(AVG(review_score),2) AS average_review_score
FROM products AS p
JOIN order_items AS oi
ON p.product_id=oi.product_id
JOIN reviews AS r
ON oi.order_id=r.order_id
GROUP BY p.product_category_name
ORDER BY average_review_score DESC;

/*
Finding:

The 'cds_dvds_musicais' category received the highest average
customer review score of 4.64, making it the highest-rated
product category on the marketplace.

Other highly rated categories include
'fashion_roupa_infanto_juvenil', 'livros_interesse_geral',
'construcao_ferramentas_ferramentas', and 'flores', all
maintaining average ratings above 4.4.

Most of the top-rated categories have average review scores
above 4.3, indicating consistently high customer satisfaction
across these product segments.

The marketplace should analyze the strengths of these
high-performing categories—such as product quality, seller
performance, and delivery experience—to replicate their
success across lower-rated categories.
*/


-- 2.21 Revenue by Payment Method

SELECT
      p.payment_type,
      ROUND(SUM(oi.price),2) AS total_revenue
FROM payments AS p
JOIN order_items AS oi
ON p.order_id=oi.order_id
GROUP BY p.payment_type
ORDER BY total_revenue DESC;

/*
Finding:

Credit card payments generated the highest revenue of approximately
10,974,357.30, making them the largest contributor to marketplace sales.

'Boleto' ranked second with approximately 2,391,525.66 in revenue,
followed by voucher payments with approximately 659,473.64.

Debit card transactions contributed the lowest revenue at only
183,758.74, indicating relatively limited customer adoption.

The revenue distribution closely aligns with the payment method
usage pattern, confirming that credit cards are both the most
frequently used and the highest revenue-generating payment method.

The marketplace can continue optimizing the credit card payment
experience while exploring strategies to increase adoption of
alternative payment methods.
*/


-- 2.22 Monthly Average Order Value (AOV) Trend

SELECT
      DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS months,
      ROUND(AVG(order_total),2) AS average_order_value
FROM
(
      SELECT
            order_id,
            SUM(payment_value) AS order_total
	  FROM payments
      GROUP BY order_id
) AS order_value 
JOIN orders as o
ON o.order_id=order_value.order_id
GROUP BY months
ORDER BY months;

/*
Finding:

The highest Average Order Value (AOV) was recorded in September 2018
at 277.47, followed by October 2018 at 182.38.

Throughout most of 2017 and 2018, the average order value remained
relatively stable between 145 and 170, indicating consistent customer
spending patterns.

The unusually high AOV in September 2018 is likely influenced by a
smaller number of high-value orders, making it an outlier rather than
a long-term trend.

Overall, the marketplace maintained a fairly consistent average order
value over time, suggesting stable pricing and customer purchasing
behavior across the observed period.
*/


-- 2.23 Repeat Customer Analysis

SELECT
	CASE
        WHEN order_count=1
        THEN "Single Purchase"
        ELSE "Repeat Customer"
	END AS customer_analysis,
    COUNT(*) as total_customers
    
FROM
(
	SELECT
          c.customer_unique_id,
          COUNT(o.order_id) AS order_count
	FROM orders as o
    JOIN customers as c
    ON o.customer_id=c.customer_id
    GROUP BY c.customer_unique_id
) as customer_orders
GROUP BY customer_analysis;

/*
Finding:

The marketplace has 93,099 single-purchase customers compared
to only 2,997 repeat customers.

This indicates that the vast majority of customers placed only
one order, while a relatively small percentage returned for
additional purchases.

The low repeat customer rate suggests an opportunity for the
business to improve customer retention through loyalty programs,
personalized marketing campaigns, and post-purchase engagement.

Increasing the proportion of repeat customers could significantly
boost long-term revenue while reducing customer acquisition costs.
*/


-- 2.24 Revenue Contribution by Product Category (%)

WITH category_revenue as
     (SELECT 
            p.product_category_name,
            ROUND(SUM(oi.price),2) AS category_revenue
	  FROM products AS p
      JOIN order_items AS oi
      ON p.product_id=oi.product_id
      GROUP BY p.product_category_name),
total_revenue as
     (SELECT
            ROUND(SUM(price),2) AS total_revenue
	  FROM order_items)
SELECT
	   product_category_name,
      ROUND((category_revenue/total_revenue)*100,2) AS category_contribution
FROM category_revenue
CROSS JOIN total_revenue
ORDER BY category_contribution DESC;
      
/*
Finding:

The revenue contribution analysis reveals that revenue is
concentrated among a relatively small number of product
categories rather than being evenly distributed across the
marketplace.

'beleza_saude' (Health & Beauty) is the highest revenue-
contributing category, generating approximately 9.26% of the
total marketplace revenue, followed by
'relogios_presentes' (Watches & Gifts) at 8.87% and
'cama_mesa_banho' (Bed, Bath & Table) at 7.63%.

Together, the top-performing categories contribute a
significant share of total sales, highlighting their
importance to overall business performance.

These insights can help the business prioritize inventory
planning, marketing campaigns, supplier partnerships, and
pricing strategies while identifying lower-contributing
categories that may benefit from promotional efforts or
portfolio optimization.
*/


-- 2.25 Seller Performance by Customer Rating

SELECT
      s.seller_id ,
      ROUND(AVG(r.review_score),2) AS average_review_score,
      COUNT(r.review_id) AS review_count
FROM sellers AS s
JOIN order_items AS oi
ON s.seller_id=oi.seller_id
JOIN reviews AS r
ON oi.order_id = r.order_id
GROUP BY s.seller_id
HAVING review_count>=20
ORDER BY average_review_score DESC;

/*
Finding:

Several sellers maintained average review scores above 4.70
while receiving at least 20 customer reviews, indicating
consistently high customer satisfaction.

Some sellers recorded average ratings between 2.10 and 3.10,
despite having a significant number of reviews, highlighting
areas where service or product quality needs improvement.

This analysis helps identify top-performing sellers for
recognition while highlighting underperforming sellers that
require quality improvement initiatives.
*/


-- 2.26 Delivery Performance by Customer State

SELECT
      c.customer_state,
      ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,o.order_purchase_timestamp)),2) AS average_delivery_time
FROM customers AS c
JOIN orders AS o
ON c.customer_id=o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_time DESC;

/*
Finding:

Delivery performance varies considerably across customer
states, indicating differences in regional logistics
efficiency across the marketplace.

Roraima (RR), Amapá (AP), and Amazonas (AM) recorded the
longest average delivery times, while São Paulo (SP),
Paraná (PR), and Minas Gerais (MG) experienced the fastest
deliveries.

The results suggest that customers located farther from
major distribution centers generally experience longer
delivery times, whereas states with stronger logistics
infrastructure receive orders more quickly.

These insights can help the business optimize warehouse
locations, improve shipping routes, and strengthen logistics
operations in regions with consistently longer delivery
times to enhance customer satisfaction.
*/
