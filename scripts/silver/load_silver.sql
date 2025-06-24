--EXEC silver.load_silver

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME  
		BEGIN TRY

		SET @batch_start_time = GETDATE();

		PRINT '============================================================='
		PRINT 'LOADING SILVER LAYER'
		PRINT '============================================================='

		PRINT '============================================================='
		PRINT 'Loading CRM Tables'
		PRINT '============================================================='

		SET @start_time = GETDATE()
		PRINT '>> Truncating the crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>>Inserting into crm_cust_info '
		INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gndr,
		cst_create_date
		)
		select cst_id, 
		cst_key, 
		TRIM(cst_firstname) as cst_firstname,
		TRIM(cst_lastname) as cst_lastname,
		CASE UPPER(TRIM(cst_gndr))
			 WHEN 'F' then 'Female'
			 WHEN 'M' then 'Male'
			 ELSE 'N/A'
		END as cst_gndr,
		CASE UPPER(TRIM(cst_material_status))
			 WHEN 'M' then 'Married'
			 WHEN 'S' then 'Single'
			 ELSE 'N/A'
		END as cst_marital_status, 
		cst_create_date
		FROM
		(
		SELECT *,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date) as flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id is not null) t
		where flag_last = 1;
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------------------'

		
		SET @start_time = GETDATE()
		PRINT '>> Truncating the crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>>Inserting into crm_prd_info '
		INSERT INTO silver.crm_prd_info (
			prd_id,
			prd_key,
			cate_id,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
			prd_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cate_id,
			prd_nm,
			ISNULL(prd_cost ,0) AS prd_cost,
			CASE UPPER(TRIM(prd_line)) 
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'other sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'N/A'
			END AS prd_line,
			prd_start_dt,
			DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
		FROM bronze.crm_prd_info
		WHERE TRY_CAST(prd_cost AS DECIMAL(18,2)) IS NOT NULL
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------------------'

		
		SET @start_time = GETDATE()
		PRINT '>> Truncating the crm_sales_data'
		TRUNCATE TABLE silver.crm_sales_data;
		PRINT '>>Inserting into crm_sales_data '
		INSERT INTO silver.crm_sales_data(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
			 ELSE CAST(CAST(sls_order_dt as varchar) as DATE)
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
			 ELSE CAST(CAST(sls_ship_dt as varchar) as DATE)
		END AS sls_ship_dt ,
		CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
			 ELSE CAST(CAST(sls_due_dt as varchar) as DATE)
		END AS sls_order_dt,
		CASE WHEN sls_sales is NULL OR sls_sales  <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
			 THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales
		END as sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN  sls_sales / NULLIF(sls_quantity, 0) ELSE sls_price END AS sls_price
		FROM bronze.crm_sales_data
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------------------'


		
		SET @start_time = GETDATE()
		PRINT '>> Truncating the erp_cust_info'
		TRUNCATE TABLE silver.erp_cust_info;
		PRINT '>>Inserting into erp_cust_info '
		INSERT INTO silver.erp_cust_info(cid, bdate, gen)
		SELECT 
		CASE WHEN cid like 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
			 ELSE cid
		END as cid, 
		CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END as bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('F', 'MALE') THEN 'Male'
			ELSE 'N/A'
		END as gen
		FROM bronze.erp_cust_info
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		
		SET @start_time = GETDATE()
		PRINT '>> Truncating the erp_cnty_data'
		TRUNCATE TABLE silver.erp_cnty_data;
		PRINT '>>Inserting into erp_cnty_data '
		INSERT INTO silver.erp_cnty_data (cid, cntry)
		select 
		REPLACE(cid, '-', '') as cid,
		CASE WHEN TRIM(cntry)  = 'DE' THEN 'Germany'
			 WHEN TRIM(CNTRY) in ('US','USA') THEN 'United States'
			 WHEN TRIM(CNTRY) = '' or cntry is null then 'N/A'
			 ELSE CNTRY
		END AS cntry
		from bronze.erp_cnty_data
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------------------'
		


		SET @start_time = GETDATE()
		PRINT '>> Truncating the erp_equip_data'
		TRUNCATE TABLE silver.erp_equip_data;
		PRINT '>>Inserting into erp_equip_data '
		INSERT INTO silver.erp_equip_data(ID,
		CAT,
		SUBCAT,
		MAINTENANCE)
		SELECT 
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		FROM bronze.erp_equip_data
		SET @end_time = GETDATe()
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------------------'

		SET @batch_end_time = GETDATE() 
		PRINT '--------------------------------------------------------'
		PRINT 'Time taken to load bronze layer : ' + CAST(DATEDIFF(second , @batch_start_time, @batch_end_time) as NVARCHAR) + ' seconds' 
		PRINT '--------------------------------------------------------'
	END TRY
	

	
	BEGIN CATCH
		PRINT '============================================================'
		PRINT 'Error Occured during loading bronze layer'
		PRINT 'ERROR MEssage' + ERROR_MESSAGE();
		PRINT 'ERROR MEssage' + CAST(ERROR_NUMBER() as NVARCHAR);
		PRINT 'ERROR MEssage' + CAST(ERROR_STATE() as NVARCHAR);
		PRINT '============================================================'
	END CATCH
END



