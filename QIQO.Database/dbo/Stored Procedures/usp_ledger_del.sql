


/*****************************************************************
**	Table Name: ledger
**	Procedure Name: usp_ledger_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_del]
	@ledger_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM ledger
	--WHERE [ledger_key] = @ledger_key
	RETURN 1;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'ledger', 'usp_ledger_del';
	THROW;
END CATCH

SET NOCOUNT OFF





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_ledger_del] TO [businessuser]
    AS [dbo];

