--EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze as
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY

		SET @batch_start_time = GETDATE();

		PRINT '============================================================='
		PRINT 'LOADING BRONZE LAYER'
		PRINT '============================================================='

		PRINT '============================================================='
		PRINT 'Loading CRM Tables'
		PRINT '============================================================='

		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT 'Inserting data into : bronze.crm_cust_info'; 
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'

		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT 'Inserting data into : bronze.crm_prd_info'; 
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'

		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.crm_sales_data';
		TRUNCATE TABLE bronze.crm_sales_data

		PRINT 'Inserting data into : bronze.crm_sales_data'
		BULK INSERT bronze.crm_sales_data
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'
		
		PRINT '============================================================='
		PRINT 'Loading CRM Tables'
		PRINT '============================================================='

		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.erp_cust_info';
		TRUNCATE TABLE bronze.erp_cust_info

		PRINT 'Inserting data into : bronze.erp_cust_info'
		BULK INSERT bronze.erp_cust_info
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_erp\cust_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'


		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.erp_cnty_data';
		TRUNCATE TABLE bronze.erp_cnty_data

		PRINT 'Inserting data into : bronze.erp_cnty_data'
		BULK INSERT bronze.erp_cnty_data
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_erp\cust_loc.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'


		SET @start_time = GETDATE();
		PRINT 'Truncating Table : bronze.erp_equip_data';
		TRUNCATE TABLE bronze.erp_equip_data
	
		PRINT 'Inserting data into : bronze.erp_equip_data'
		BULK INSERT bronze.erp_equip_data
		FROM 'C:\Users\Azhagan\Desktop\Upskill and projects\Datawarehouse Project\sql-data-warehouse-project\datasets\source_erp\cat_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);		
		SET @end_time= GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------'

		SET @batch_end_time = GETDATE() 
		PRINT '--------------------------------------------------------'
		PRINT 'Time taken to load bronze layer : ' + CAST(DATEDIFF(second , @batch_start_time, @batch_end_time) as NVARCHAR) 
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
