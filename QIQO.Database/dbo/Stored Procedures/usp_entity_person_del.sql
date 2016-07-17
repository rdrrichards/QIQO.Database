

/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_del]
	@entity_person_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	UPDATE entity_person SET
	end_date = GETDATE()
	WHERE [entity_person_key] = @entity_person_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_del';
	THROW;
END CATCH

SET NOCOUNT OFF



