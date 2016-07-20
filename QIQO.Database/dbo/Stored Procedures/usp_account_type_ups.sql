



/*****************************************************************
**	Table Name: account_type
**	Procedure Name: usp_account_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_type_ups]

	@account_type_key int,
	@account_type_code varchar(10),
	@account_type_name varchar(50),
	@account_type_desc varchar(254),
	@key int out
AS
SET NOCOUNT ON
IF @account_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR account_type_key_seq;
	INSERT INTO account_type ([account_type_key],
		[account_type_code],
		[account_type_name],
		[account_type_desc]
	)
	VALUES (@new_key,
		@account_type_code,
		@account_type_name,
		@account_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'account_type', 'usp_account_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE account_type SET 
		[account_type_code] = @account_type_code,
		[account_type_name] = @account_type_name,
		[account_type_desc] = @account_type_desc
	WHERE [account_type_key] = @account_type_key
		AND ([account_type_code] <> @account_type_code
		OR [account_type_name] <> @account_type_name
		OR [account_type_desc] <> @account_type_desc);
	SELECT @key = @account_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'account_type', 'usp_account_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_type_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_type_ups] TO [businessuser]
    AS [dbo];

