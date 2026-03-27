-- Query 6: Churn Risk Segmentation
-- Purpose: Classify every customer as Active, At Risk, or Churned
-- Based on how many days since their last purchase (analysis date = 2011-12-09)
-- Active = bought within last 90 days
-- At Risk = silent for 91-180 days (recoverable with win-back campaign)
-- Churned = silent for 180+ days (very hard to recover)

WITH cleaned AS (
  SELECT
    `Customer ID`                                                   AS CustomerID,
    Invoice,
    DATE(InvoiceDate)                                               AS invoice_date,
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
  CustomerID,
  MAX(invoice_date)                                                 AS last_purchase_date,
  COUNT(DISTINCT Invoice)                                           AS order_count,
  ROUND(SUM(revenue), 2)                                           AS total_revenue,
  DATE_DIFF(DATE '2011-12-09', MAX(invoice_date), DAY)             AS days_since_purchase,
  CASE
    WHEN DATE_DIFF(DATE '2011-12-09', MAX(invoice_date), DAY) <= 90  THEN 'Active'
    WHEN DATE_DIFF(DATE '2011-12-09', MAX(invoice_date), DAY) <= 180 THEN 'At Risk'
    ELSE                                                                  'Churned'
  END                                                               AS churn_risk
FROM cleaned
GROUP BY CustomerID
ORDER BY days_since_purchase DESC
