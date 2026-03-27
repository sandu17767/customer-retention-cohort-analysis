-- Query 1: Data Quality Audit
-- Purpose: Understand the raw data before cleaning anything
-- Run this first to see what needs to be fixed

SELECT
  COUNT(*)                                                          AS total_rows,
  COUNT(DISTINCT `Customer ID`)                                     AS total_customers,
  COUNT(DISTINCT Invoice)                                           AS total_invoices,
  COUNTIF(`Customer ID` IS NULL)                                    AS missing_customer_id,
  COUNTIF(Quantity <= 0)                                            AS negative_or_zero_qty,
  COUNTIF(Price <= 0)                                               AS negative_or_zero_price,
  COUNTIF(STARTS_WITH(CAST(Invoice AS STRING), 'C'))                AS cancellations,
  MIN(InvoiceDate)                                                  AS earliest_date,
  MAX(InvoiceDate)                                                  AS latest_date,
  COUNT(DISTINCT Country)                                           AS countries
FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.online_retail`
