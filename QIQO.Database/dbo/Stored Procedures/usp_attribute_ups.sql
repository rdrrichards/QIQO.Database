



/*****************************************************************
**	Table Name: attribute
**	Procedure Name: usp_attribute_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_ups]

	@attribute_key int,
	@entity_key int,
	@entity_type_key int,
	@attribute_type_key int,
	@attribute_value varchar(MAX),
	@attribute_data_type_key int,
	@attribute_display_format varchar(50),
	@key int out
AS
SET NOCOUNT ON
IF @attribute_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR attribute_key_seq;
	INSERT INTO attribute ([attribute_key],
		[entity_key],
		[entity_type_key],
		[attribute_type_key],
		[attribute_value],
		[attribute_data_type_key],
		[attribute_display_format]
	)
	VALUES (@new_key,
		@entity_key,
		@entity_type_key,
		@attribute_type_key,
		@attribute_value,
		@attribute_data_type_key,
		@attribute_display_format
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'attribute', 'usp_attribute_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE attribute SET 
		[entity_key] = @entity_key,
		[entity_type_key] = @entity_type_key,
		[attribute_type_key] = @attribute_type_key,
		[attribute_value] = @attribute_value,
		[attribute_data_type_key] = @attribute_data_type_key,
		[attribute_display_format] = @attribute_display_format
	WHERE [attribute_key] = @attribute_key
		AND ([entity_key] <> @entity_key
		OR [entity_type_key] <> @entity_type_key
		OR [attribute_type_key] <> @attribute_type_key
		OR [attribute_value] <> @attribute_value
		OR [attribute_data_type_key] <> @attribute_data_type_key
		OR [attribute_display_format] <> @attribute_display_format);
	SELECT @key = @attribute_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'attribute', 'usp_attribute_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_ups] TO [businessuser]
    AS [dbo];

