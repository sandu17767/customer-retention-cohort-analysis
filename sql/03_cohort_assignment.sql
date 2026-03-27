-- Query 3: Cohort Assignment
-- Purpose: Assign each customer to their first-purchase month
-- This is how cohorts are defined — every customer belongs to the month they first bought

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
),

first_purchase AS (
  SELECT
    CustomerID,
    DATE_TRUNC(MIN(invoice_date), MONTH)                            AS cohort_month
  FROM cleaned
  GROUP BY CustomerID
)

SELECT
  cohort_month,
  COUNT(DISTINCT CustomerID)                                        AS cohort_size
FROM first_purchase
GROUP BY cohort_month
ORDER BY cohort_month
