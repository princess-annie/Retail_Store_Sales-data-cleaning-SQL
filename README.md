# Data Cleaning Project with SQL  
***
This project is a practical demonstration of data preparation, data cleaning, validation and data quality assesment using SQL in 
which the dataset is reliable, structured and ready for analysis. Through a systematic SQL data cleaning process, the dataset was transformed
into an analysis ready format suitable for reporting and decision making.

*Steps taken while cleaning this dataset
1. Understanding the Data Structure
2. Identify the data quality issues
- Check for missing values
- Check for duplicate values in all rows
- Check for Inconsistent data
- Check for data formats
3. Add derived/calculated columns like 'Month' and 'Year'
4. Create Backup for your data
5. Cleaning Execution
- for item, we replace the empty string with Unknown
- for price_per_unit, quantity and total_spent we replace with Null
- for discount_applied, will replace with false beccause empty string might mean no discount was applied

