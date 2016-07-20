

/*****************************************************************
**	Table Name: chart_of_accounts
**	Procedure Name: usp_chart_of_accounts_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_chart_of_accounts_del]
	@coa_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM chart_of_accounts
	WHERE [coa_key] = @coa_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'chart_of_accounts', 'usp_chart_of_accounts_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_chart_of_accounts_del] TO [businessuser]
    AS [dbo];

