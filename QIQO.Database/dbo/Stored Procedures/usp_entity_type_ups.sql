



/*****************************************************************
**	Table Name: entity_type
**	Procedure Name: usp_entity_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_type_ups]

	@entity_type_key int,
	@entity_type_code varchar(10),
	@entity_type_name varchar(50),
	@key int out
AS
SET NOCOUNT ON
IF @entity_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR entity_type_key_seq;
	INSERT INTO entity_type ([entity_type_key],
		[entity_type_code],
		[entity_type_name]
	)
	VALUES (@new_key,
		@entity_type_code,
		@entity_type_name
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_type', 'usp_entity_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE entity_type SET 
		[entity_type_code] = @entity_type_code,
		[entity_type_name] = @entity_type_name
	WHERE [entity_type_key] = @entity_type_key
		AND ([entity_type_code] <> @entity_type_code
		OR [entity_type_name] <> @entity_type_name);
	SELECT @key = @entity_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_type', 'usp_entity_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_type_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_type_ups] TO [businessuser]
    AS [dbo];

