-- Query 4: Cohort Retention Matrix
-- Purpose: Build the full month-by-month retention rate for every cohort
-- Output: Export this as CSV and load into Power BI for the retention heatmap

WITH cleaned AS (
  SELECT
    `Customer ID`                                                   AS CustomerID,
    Invoice,
    DATE(InvoiceDate)                                               AS invoice_date
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
),

customer_activity AS (
  SELECT
    c.CustomerID,
    fp.cohort_month,
    DATE_TRUNC(c.invoice_date, MONTH)                               AS activity_month,
    DATE_DIFF(
      DATE_TRUNC(c.invoice_date, MONTH),
      fp.cohort_month,
      MONTH
    )                                                               AS month_number
  FROM cleaned c
  JOIN first_purchase fp USING (CustomerID)
),

cohort_counts AS (
  SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT CustomerID)                                      AS active_customers
  FROM customer_activity
  GROUP BY cohort_month, month_number
),

cohort_sizes AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT CustomerID)                                      AS cohort_size
  FROM first_purchase
  GROUP BY cohort_month
)

SELECT
  cc.cohort_month,
  cs.cohort_size,
  cc.month_number,
  cc.active_customers,
  ROUND(cc.active_customers / cs.cohort_size * 100, 1)             AS retention_rate_pct
FROM cohort_counts cc
JOIN cohort_sizes cs USING (cohort_month)
ORDER BY cohort_month, month_number
