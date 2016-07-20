

/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_del_o]
	@person_key int,
	@person_type_key int,
	@entity_key int,
	@entity_type_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	UPDATE entity_person SET
	end_date = GETDATE()
	WHERE [person_key] = @person_key
		AND person_type_key = @person_type_key
		AND entity_person_seq = 1
		AND entity_key = @entity_key
		AND entity_type_key = @entity_type_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_del_o';
	THROW;
END CATCH

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_del_o] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_del_o] TO [businessuser]
    AS [dbo];

