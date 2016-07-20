

/*****************************************************************
**	Table Name: company
**	Procedure Name: usp_company_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_company_del_c]
	@company_code int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM company
	WHERE [company_code] = @company_code;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'company', 'usp_company_del';
	THROW;
END CATCH

SET NOCOUNT OFF





GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_company_del_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_company_del_c] TO [businessuser]
    AS [dbo];

