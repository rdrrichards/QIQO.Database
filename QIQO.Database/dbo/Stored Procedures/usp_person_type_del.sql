

/*****************************************************************
**	Table Name: person_type
**	Procedure Name: usp_person_type_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_type_del]
	@person_type_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM person_type
	WHERE [person_type_key] = @person_type_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'person_type', 'usp_person_type_del';
	THROW;
END CATCH

SET NOCOUNT OFF



