--Check for nulls or duplicates in primary key
--Expectation : No Result

SELECT 
cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id is  null


-- Check unwanted spaces
--Expectation : No Result

select cst_firstname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname)


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'silver' and TABLE_NAME = ''

