-- Database select karein
USE customer_behaviour;

-- Table dekhne ke liye
SELECT *
FROM customer_shopping
LIMIT 10;

-- Table ke columns check karein
DESCRIBE customer_shopping;

-- Gender-wise total revenue
SELECT
    Gender,
    SUM(`Purchase Amount (USD)`) AS Revenue
FROM customer_shopping
GROUP BY Gender;
-- which customers used a discount but still spent more than the average purchase amount?
SELECT `Customer ID`, `Purchase Amount (USD)`
FROM customer_shopping
WHERE `Discount Applied` = 'Yes'
  AND `Purchase Amount (USD)` >= (
      SELECT AVG(`Purchase Amount (USD)`)
      FROM customer_shopping
  );
-- which are the 5 product with the highest average review rating
use customer_behaviour;
SELECT `Item Purchased`,
       AVG(`Review Rating`) AS `Average Product Rating`
FROM `customer_shopping`
GROUP BY `Item Purchased`
ORDER BY `Average Product Rating` DESC
LIMIT 5;
-- compare the average purchase Amount between standard and Express Shipping
SELECT `Shipping Type`,
       ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount
FROM customer_shopping
WHERE `Shipping Type` IN ('Standard', 'Express')
GROUP BY `Shipping Type`;
-- do describe customers spend more? compare average spend and total revenue between subscriber and non subscribers.
SELECT
    `Subscription Status`,
    COUNT(*) AS `Number of Customers`,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS `Average Spend`,
    SUM(`Purchase Amount (USD)`) AS `Total Revenue`
FROM customer_shopping
GROUP BY `Subscription Status`;
-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT
    `Item Purchased`,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS `Discount Rate`
FROM customer_shopping
GROUP BY `Item Purchased`
ORDER BY `Discount Rate` DESC
LIMIT 5;
-- Q7 Segment customers into New, Returning, and Loyal based on previous purchases, and show the count of each segment.
SELECT
    CASE
        WHEN `Previous Purchases` = 1 THEN 'New'
        WHEN `Previous Purchases` BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS `Customer Segment`,
    COUNT(*) AS `Number of Customers`
FROM customer_shopping
GROUP BY `Customer Segment`;
-- Q8 What are the top 3 most purchased products within each category?
WITH item_counts AS (
    SELECT
        `Category`,
        `Item Purchased`,
        COUNT(*) AS `Total Orders`,
        ROW_NUMBER() OVER (
            PARTITION BY `Category`
            ORDER BY COUNT(*) DESC
        ) AS `Item Rank`
    FROM customer_shopping
    GROUP BY `Category`, `Item Purchased`
)
SELECT
    `Item Rank`,
    `Category`,
    `Item Purchased`,
    `Total Orders`
FROM item_counts
WHERE `Item Rank` <= 3
ORDER BY `Category`, `Item Rank`;
-- Q9. Are customers who are repeat buyers (>5 previous purchases) also likely to subscribe?
SELECT
    `Subscription Status`,
    COUNT(`Customer ID`) AS repeat_buyers
FROM customer_shopping
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;
-- Q10. What is the revenue contribution of each age group?
SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer_shopping
GROUP BY age_group
ORDER BY total_revenue DESC;