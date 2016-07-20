

/*****************************************************************
**	Table Name: account
**	Procedure Name: usp_account_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_account_del]
	@account_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM account
	--WHERE [account_key] = @account_key
	UPDATE account SET account_end_date = GETDATE()
	WHERE account_key = @account_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'account', 'usp_account_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_account_del] TO [businessuser]
    AS [dbo];

