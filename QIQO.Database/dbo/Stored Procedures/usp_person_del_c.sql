

/*****************************************************************
**	Table Name: person
**	Procedure Name: usp_person_del_c
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_del_c]
	@person_code varchar(10),
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM person
	WHERE [person_code] = @person_code;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'person', 'usp_person_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_del_c] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_del_c] TO [businessuser]
    AS [dbo];

