

/*****************************************************************
**	Table Name: attribute_type
**	Procedure Name: usp_attribute_type_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_type_del]
	@attribute_type_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM attribute_type
	WHERE [attribute_type_key] = @attribute_type_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'attribute_type', 'usp_attribute_type_del';
	THROW;
END CATCH

SET NOCOUNT OFF




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_type_del] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_type_del] TO [businessuser]
    AS [dbo];

