-- First step while data cleaning
-- Inspect the table structure to know the column data type (11 Columns)
DESCRIBE retail_transactions;

-- Total records in this dataset (12,575 records)
SELECT COUNT(*) AS total_rows 
FROM retail_transactions;

-- View sample data to understand it
Select * from retail_transactions LIMIT 50;

-- Always backup before cleaning to maintain the original data!
CREATE TABLE retail_transactions_backup_20260120 AS 
SELECT * FROM retail_transactions;
-- Verify backup
SELECT COUNT(*) FROM retail_transactions_backup;

-- Secondly, Understand the distribution in your data
-- Count distinct values in categorical column
SELECT 
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT category) AS unique_categories,
    COUNT(DISTINCT item) AS unique_items,
    COUNT(DISTINCT payment_method) AS unique_payment_methods,
    COUNT(DISTINCT location) AS unique_locations
FROM retail_transactions;

-- Results
-- had 12,575 unique transaction id
-- had 25 unique customers id
-- had 8 unique categories
-- had 201 unique items
-- had 3 unique payments_method
-- had 2 unique locations

-- Summary Staistics for numeric column
SELECT 
    -- Price per unit 
    AVG(price_per_unit) AS avg_unit_price, (22.234)
    MIN(price_per_unit) AS min_unit_price, (0.00)
    MAX(price_per_unit) AS max_unit_price, (41.00)
    SUM(price_per_unit) AS total_price, (279596.50)
    
    -- Quantity
    AVG(quantity) AS avg_items_per_transaction, (5.2705)
    MIN(quantity) AS min_quantity, (0)
    MAX(quantity) AS max_quantity, (10)
    SUM(quantity) AS total_items_sold, (66276)
    
    -- Total spent
   AVG(total_spent) AS avg_transaction_value, (123.425)
   MIN(total_spent) AS min_transaction, (0.00)
   MAX(total_spent) AS max_transaction, (410.00)
   SUM(total_spent) AS total_revenue (1552071.00)
FROM retail_transactions;

-- Thirdly, we will identify data quality issues
-- Checking for missing values in all columns
SELECT 
    SUM(CASE WHEN transaction_id IS NULL OR transaction_id = '' THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN category IS NULL OR category = '' THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN item IS NULL OR item = '' THEN 1 ELSE 0 END) AS missing_item,
    SUM(CASE WHEN price_per_unit IS NULL OR price_per_unit = 0 THEN 1 ELSE 0 END) AS missing_price_per_unit,
    SUM(CASE WHEN quantity IS NULL OR quantity = 0 THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN total_spent IS NULL OR total_spent = 0 THEN 1 ELSE 0 END) AS missing_total_spent,
    SUM(CASE WHEN payment_method IS NULL OR payment_method = '' THEN 1 ELSE 0 END) AS missing_payment_method,
    SUM(CASE WHEN location IS NULL OR location = '' THEN 1 ELSE 0 END) AS missing_location,
    SUM(CASE WHEN transaction_date IS NULL OR transaction_date = '0000-00-00' THEN 1 ELSE 0 END) AS missing_transaction_date,
    SUM(CASE WHEN discount_applied IS NULL OR discount_applied = '' THEN 1 ELSE 0 END) AS missing_discount_applied
FROM retail_transactions;

-- Check for duplicates
SELECT 
    COUNT(*) - COUNT(DISTINCT transaction_id, customer_id, category, item, 
                     price_per_unit, quantity, total_spent, payment_method, 
                     location, transaction_date, discount_applied) AS total_duplicate_rows
FROM retail_transactions;

--Results
-- no duplicates was found

-- Check for inconsistencies
-- Remove leading/trailing spaces
UPDATE retail_transactions
SET 
    category = TRIM(category),
    item = TRIM(item),
    payment_method = TRIM(payment_method),
    location = TRIM(location),
    discount_applied = TRIM(discount_applied);

-- Standardize discount_applied
UPDATE retail_transactions
SET discount_applied = 'True' 
WHERE discount_applied IN ('true', 'TRUE', 'T', 'Yes', 'yes', '1'); 
--(4,219 were replaced)

UPDATE retail_transactions
SET discount_applied = 'False'
WHERE discount_applied IN ('false', 'FALSE', 'F', 'No', 'no', '0'); 
--(8,356 were replaced)

-- how to handle missing values for each column
-- for item, we replace the empty string with Unknown
UPDATE retail_transactions
SET item = 'Unknown'
WHERE item IS NULL OR item = '';
-- 609 columns were replaced

-- for price_per_unit, quantity and total_spent we replace with Null
UPDATE retail_transactions
SET price_per_unit = 'NULL'
WHERE price_per_unit = '';
-- 609 columns replaced

UPDATE retail_transactions
SET quantity = 'NULL'
WHERE quantity = '';
-- 604 columns replaced

UPDATE retail_transactions
SET total_spent = 'NULL'
WHERE total_spent = '';
-- 604 columns replaced

-- for discount_applied, will replace with false beccause empty string might mean no discount was applied
UPDATE retail_transactions
SET discount_applied = 'False'
WHERE discount_applied = '';


