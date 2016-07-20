

/*****************************************************************
**	Table Name: fee_schedule
**	Procedure Name: usp_fee_schedule_ups
**	Author: Richard Richards
**	Created: 07/15/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_fee_schedule_ups]

	@fee_schedule_key int,
	@company_key int,
	@account_key int,
	@product_key int,
	@fee_schedule_start_date datetime,
	@fee_schedule_end_date datetime,
	@fee_schedule_type char(1),
	@fee_schedule_value float,
	@key int out
AS
SET NOCOUNT ON
IF @fee_schedule_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR fee_schedule_key_seq;
	INSERT INTO fee_schedule ([fee_schedule_key],
		[company_key],
		[account_key],
		[product_key],
		[fee_schedule_start_date],
		[fee_schedule_end_date],
		[fee_schedule_type],
		[fee_schedule_value]
	)
	VALUES (@new_key,
		@company_key,
		@account_key,
		@product_key,
		@fee_schedule_start_date,
		@fee_schedule_end_date,
		@fee_schedule_type,
		@fee_schedule_value
	)
	SELECT @key = @new_key
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'fee_schedule', 'usp_fee_schedule_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE fee_schedule SET 
		[company_key] = @company_key,
		[account_key] = @account_key,
		[product_key] = @product_key,
		[fee_schedule_start_date] = @fee_schedule_start_date,
		[fee_schedule_end_date] = @fee_schedule_end_date,
		[fee_schedule_type] = @fee_schedule_type,
		[fee_schedule_value] = @fee_schedule_value
	WHERE [fee_schedule_key] = @fee_schedule_key
		AND ([company_key] <> @company_key
		OR [account_key] <> @account_key
		OR [product_key] <> @product_key
		OR [fee_schedule_start_date] <> @fee_schedule_start_date
		OR [fee_schedule_end_date] <> @fee_schedule_end_date
		OR [fee_schedule_type] <> @fee_schedule_type
		OR [fee_schedule_value] <> @fee_schedule_value);
	
	SELECT @key = @fee_schedule_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'fee_schedule', 'usp_fee_schedule_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_fee_schedule_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_fee_schedule_ups] TO [businessuser]
    AS [dbo];

