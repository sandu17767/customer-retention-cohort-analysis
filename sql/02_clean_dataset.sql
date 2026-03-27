-- Query 2: Clean Dataset
-- Purpose: Remove all noise from the raw data
-- This CTE becomes the foundation for ALL subsequent queries
-- Filters: UK only, removes nulls, cancellations, returns, zero-price rows

WITH cleaned AS (
  SELECT
    `Customer ID`                                                   AS CustomerID,
    Invoice,
    InvoiceDate,
    DATE(InvoiceDate)                                               AS invoice_date,
    Quantity,
    Price,
    ROUND(Quantity * Price, 2)                                      AS revenue,
    Country
  FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.online_retail`
  WHERE
    `Customer ID` IS NOT NULL
    AND Quantity > 0
    AND Price > 0
    AND NOT STARTS_WITH(CAST(Invoice AS STRING), 'C')
    AND Country = 'United Kingdom'
)

SELECT
  COUNT(*)                            AS clean_rows,
  COUNT(DISTINCT CustomerID)          AS unique_customers,
  COUNT(DISTINCT Invoice)             AS unique_orders,
  ROUND(SUM(revenue), 2)              AS total_revenue,
  ROUND(AVG(revenue), 2)              AS avg_line_item_value,
  MIN(invoice_date)                   AS date_from,
  MAX(invoice_date)                   AS date_to
FROM cleaned
