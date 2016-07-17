



/*****************************************************************
**	Table Name: account
**	Procedure Name: usp_account_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_ups]

	@account_key int,
	@company_key int,
	@account_type_key int,
	@account_code varchar(30),
	@account_name varchar(150),
	@account_desc varchar(254),
	@account_dba varchar(150),
	@account_start_date datetime,
	@account_end_date datetime,
	@key int out
AS
SET NOCOUNT ON
IF @account_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR account_key_seq;
	INSERT INTO account ([account_key],
		[company_key],
		[account_type_key],
		[account_code],
		[account_name],
		[account_desc],
		[account_dba],
		[account_start_date],
		[account_end_date]
	)
	VALUES (@new_key,
		@company_key,
		@account_type_key,
		@account_code,
		@account_name,
		@account_desc,
		@account_dba,
		@account_start_date,
		@account_end_date
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'account', 'usp_account_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE account SET 
		[company_key] = @company_key,
		[account_type_key] = @account_type_key,
		[account_code] = @account_code,
		[account_name] = @account_name,
		[account_desc] = @account_desc,
		[account_dba] = @account_dba,
		[account_start_date] = @account_start_date,
		[account_end_date] = @account_end_date
	WHERE [account_key] = @account_key
	AND ([company_key] <> @company_key
		OR [account_type_key] <> @account_type_key
		OR [account_code] <> @account_code
		OR [account_name] <> @account_name
		OR [account_desc] <> @account_desc
		OR [account_dba] <> @account_dba
		OR [account_start_date] <> @account_start_date
		OR [account_end_date] <> @account_end_date);
	SELECT @key = @account_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'account', 'usp_account_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






