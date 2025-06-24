
CREATE VIEW gold.dim_customers as 
SELECT 
ROW_NUMBER() OVER(ORDER BY cst_id) as customer_key,
cst_id customer_id,
cst_key customer_number,
cst_firstname first_name,
cst_lastname last_name,
cnt.CNTRY country,
cst_material_status marital_status,
CASE WHEN cci.cst_gndr != 'N/A' THEN eci.GEN 
	 ELSE COALESCE(eci.GEN, 'N/A')
END as gender,
cst_create_date create_date,
eci.BDATE birth_date
FROM silver.crm_cust_info cci
LEFT JOIN silver.erp_cust_info eci ON cci.cst_key = eci.CID
LEFT JOIN silver.erp_cnty_data cnt ON cnt.CID = cci.cst_key




CREATE VIEW gold.dim_products as 
SELECT 
ROW_NUMBER() OVER(ORDER BY prd_start_dt, prd.prd_key) as product_key, 
prd_id product_id,
prd_nm product_number, 
prd_key product_name,
cate_id category_id,
eq.cat category,
eq.subcat subcategory,
eq.maintenance,
prd_cost cost,
prd_line product_line,
prd_start_dt start_date
FROM silver.crm_prd_info prd 
LEFT JOIN silver.erp_equip_data eq ON prd.cate_id = eq.id
where prd_end_dt is null -- Filter out all historical data


CREATE VIEW gold.fact_sales as
select
sls_ord_num order_number,
pr.product_key,
cs.customer_key,
sls_order_dt order_date,
sls_ship_dt shipping_date,
sls_due_dt due_date,
sls_sales sales_amount,
sls_quantity quantity,
sls_price price
from silver.crm_sales_data sd 
LEFT JOIN gold.dim_products pr on sd.sls_prd_key = pr.product_name
LEFT JOIN gold.dim_customers cs on sd.sls_cust_id = cs.customer_id




select * 
from gold.dim_products

select * 
from gold.dim_products




select COLUMN_NAME
from information_schema.COLUMNS
where table_schema = 'silver' and table_name = 'crm_sales_data'
