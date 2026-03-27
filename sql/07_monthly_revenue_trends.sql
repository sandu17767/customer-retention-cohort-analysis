-- Query 7: Month-over-Month Revenue & Customer Trends
-- Purpose: Track revenue, orders, active customers, and AOV across 25 months
-- Shows seasonality, peak months (Oct-Nov), danger months (Jan-Feb),
-- and the December AOV spike driven by bulk Christmas stock orders

WITH cleaned AS (
  SELECT
    `Customer ID`                                                   AS CustomerID,
    Invoice,
    DATE_TRUNC(DATE(InvoiceDate), MONTH)                           AS order_month,
    ROUND(Quantity * Price, 2)                                      AS revenue
  FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.online_retail`
  WHERE
    `Customer ID` IS NOT NULL
    AND Quantity > 0
    AND Price > 0
    AND NOT STARTS_WITH(CAST(Invoice AS STRING), 'C')
    AND Country = 'United Kingdom'
)

SELECT
  order_month,
  COUNT(DISTINCT CustomerID)                                        AS active_customers,
  COUNT(DISTINCT Invoice)                                           AS total_orders,
  ROUND(SUM(revenue), 2)                                           AS monthly_revenue,
  ROUND(SUM(revenue) / COUNT(DISTINCT Invoice), 2)                 AS avg_order_value
FROM cleaned
GROUP BY order_month
ORDER BY order_month
