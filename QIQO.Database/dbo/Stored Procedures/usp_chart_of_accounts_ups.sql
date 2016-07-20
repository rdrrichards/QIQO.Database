



/*****************************************************************
**	Table Name: chart_of_accounts
**	Procedure Name: usp_chart_of_accounts_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_chart_of_accounts_ups]

	@coa_key int,
	@company_key int,
	@acct_no varchar(10),
	@acct_type varchar(30),
	@acct_name varchar(50),
	@balance_type varchar(10),
	@bank_acct_flg char(1),
	--@department_no varchar(10),
	--@lob_no varchar(10),
	@key int out
AS
SET NOCOUNT ON
IF @coa_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR chart_of_accounts_key_seq;
	INSERT INTO chart_of_accounts ([coa_key],
		[company_key],
		[acct_no],
		[acct_name],
		[acct_type],
		--[department_no], 
		--[lob_no], 
		[balance_type],
		[bank_acct_flg]
	)
	VALUES (@new_key,
		@company_key,
		@acct_no,
		@acct_type,
		--@department_no,
		--@lob_no
		@acct_name,
		@balance_type,
		@bank_acct_flg
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'chart_of_accounts', 'usp_chart_of_accounts_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE chart_of_accounts SET 
		[company_key] = @company_key,
		[acct_no] = @acct_no,
		[acct_name] = @acct_name,
		[acct_type] = @acct_type,
		--[department_no] = @department_no,
		--[lob_no] = @lob_no
		[balance_type] = @balance_type,
		[bank_acct_flg] = @bank_acct_flg
	WHERE [coa_key] = @coa_key
		AND ([company_key] <> @company_key
			OR [acct_no] <> @acct_no
			OR [acct_name] <> @acct_name
			OR [acct_type] <> @acct_type
			OR [balance_type] <> @balance_type
			OR [bank_acct_flg] <> @bank_acct_flg);
	SELECT @key = @coa_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'chart_of_accounts', 'usp_chart_of_accounts_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_ups] TO [businessuser]
    AS [dbo];

