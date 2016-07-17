


/*****************************************************************
**	Table Name: ledger_txn
**	Procedure Name: usp_ledger_txn_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_ledger_txn_del]
	@ledger_txn_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	--DELETE FROM ledger_txn
	--WHERE [ledger_txn_key] = @ledger_txn_key
	RETURN 1;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'ledger_txn', 'usp_ledger_txn_del';
	THROW;
END CATCH

SET NOCOUNT OFF




