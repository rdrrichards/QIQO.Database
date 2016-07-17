

/*****************************************************************
**	Table Name: attribute
**	Procedure Name: usp_attribute_del
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_del]
	@attribute_key int,
	@key int out
AS
SET NOCOUNT ON

BEGIN TRY
	DELETE FROM attribute
	WHERE [attribute_key] = @attribute_key;
	SELECT @key = @@ROWCOUNT;
END TRY
BEGIN CATCH
		EXEC usp_LogError 'attribute', 'usp_attribute_del';
	THROW;
END CATCH

SET NOCOUNT OFF



