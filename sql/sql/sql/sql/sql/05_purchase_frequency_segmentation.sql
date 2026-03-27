-- Query 5: Purchase Frequency Segmentation
-- Purpose: Segment customers by how many times they ordered
-- Shows the 80/20 split — how a small group of loyal buyers drives most revenue

WITH cleaned AS (
  SELECT
    `Customer ID`                                                   AS CustomerID,
    Invoice,
    ROUND(Quantity * Price, 2)                                      AS revenue
  FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.online_retail`
  WHERE
    `Customer ID` IS NOT NULL
    AND Quantity > 0
    AND Price > 0
    AND NOT STARTS_WITH(CAST(Invoice AS STRING), 'C')
    AND Country = 'United Kingdom'
),

customer_summary AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT Invoice)                                         AS order_count,
    ROUND(SUM(revenue), 2)                                         AS total_revenue
  FROM cleaned
  GROUP BY CustomerID
)

SELECT
  CASE
    WHEN order_count = 1              THEN '1. One-Time Buyer'
    WHEN order_count = 2              THEN '2. Returning (2 orders)'
    WHEN order_count BETWEEN 3 AND 5  THEN '3. Occasional (3-5 orders)'
    ELSE                                   '4. Loyal (6+ orders)'
  END                                                               AS segment,
  COUNT(*)                                                          AS customer_count,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1)                AS pct_of_customers,
  ROUND(SUM(total_revenue), 2)                                     AS segment_revenue,
  ROUND(SUM(total_revenue) / SUM(SUM(total_revenue)) OVER () * 100, 1) AS pct_of_revenue
FROM customer_summary
GROUP BY segment
ORDER BY segment
