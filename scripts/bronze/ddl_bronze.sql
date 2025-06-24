IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
	cst_id INT, 
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id        VARCHAR(50),
    prd_key       VARCHAR(50),
    prd_nm        VARCHAR(100),
    prd_cost      DECIMAL(18, 2),
    prd_line      VARCHAR(100),
    prd_start_dt  DATE,
    prd_end_dt    DATE
);

IF OBJECT_ID ('bronze.crm_sales_data', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_data;
CREATE TABLE bronze.crm_sales_data (
    sls_ord_num    VARCHAR(50),
    sls_prd_key    VARCHAR(50),
    sls_cust_id    VARCHAR(50),
    sls_order_dt   VARCHAR(50),
    sls_ship_dt    VARCHAR(50),
    sls_due_dt     VARCHAR(50),
    sls_sales      DECIMAL(18, 2),
    sls_quantity   INT,
    sls_price      DECIMAL(18, 2)
);

IF OBJECT_ID ('bronze.erp_cnty_data', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cnty_data;
CREATE TABLE bronze.erp_cnty_data (
    CID    VARCHAR(50),
    CNTRY  VARCHAR(100)
);

IF OBJECT_ID ('bronze.erp_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_info;
CREATE TABLE bronze.erp_cust_info (
    CID    VARCHAR(50),
    BDATE  DATE,
    GEN    VARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_equip_data', 'U') IS NOT NULL
	DROP TABLE bronze.erp_equip_data;
CREATE TABLE bronze.erp_equip_data (
    ID           VARCHAR(50),
    CAT          VARCHAR(100),
    SUBCAT       VARCHAR(100),
    MAINTENANCE  VARCHAR(100)
);
