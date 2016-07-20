




/*****************************************************************
**	Table Name: ledger
**	Procedure Name: usp_ledger_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_ups]

	@ledger_key int,
	@company_key int,
	--@coa_key int,
	@ledger_code varchar(10),
	@ledger_name varchar(50),
	@ledger_desc varchar(255),
	@key int out
AS
SET NOCOUNT ON
IF @ledger_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR ledger_key_seq;
	INSERT INTO ledger ([ledger_key],
		[company_key],
		--[coa_key],
		[ledger_code],
		[ledger_name],
		[ledger_desc]
	)
	VALUES (@new_key,
		@company_key,
		--@coa_key,
		@ledger_code,
		@ledger_name,
		@ledger_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'ledger', 'usp_ledger_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE ledger SET 
		[company_key] = @company_key,
		--[coa_key] = @coa_key,
		[ledger_code] = @ledger_code,
		[ledger_name] = @ledger_name,
		[ledger_desc] = @ledger_desc
	WHERE [ledger_key] = @ledger_key;
	SELECT @key = @ledger_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'ledger', 'usp_ledger_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF








GO
GRANT EXECUTE
	ON OBJECT::[dbo].[usp_ledger_ups] TO [RDRRL8\QIQOServiceAccount]
	AS [dbo];


GO
GRANT EXECUTE
	ON OBJECT::[dbo].[usp_ledger_ups] TO [businessuser]
	AS [dbo];

