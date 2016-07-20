



/*****************************************************************
**	Table Name: attribute_type
**	Procedure Name: usp_attribute_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_attribute_type_ups]

	@attribute_type_key int,
	@attribute_type_category varchar(50),
	@attribute_type_code varchar(10),
	@attribute_type_name varchar(50),
	@attribute_type_desc varchar(150),
	@attribute_data_type_key int,
	@attribute_default_format varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @attribute_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR attribute_type_key_seq;
	INSERT INTO attribute_type ([attribute_type_key],
		[attribute_type_category],
		[attribute_type_code],
		[attribute_type_name],
		[attribute_type_desc],
		[attribute_data_type_key],
		[attribute_default_format]
	)
	VALUES (@new_key,
		@attribute_type_category,
		@attribute_type_code,
		@attribute_type_name,
		@attribute_type_desc,
		@attribute_data_type_key,
		@attribute_default_format
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'attribute_type', 'usp_attribute_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE attribute_type SET 
		[attribute_type_category] = @attribute_type_category,
		[attribute_type_code] = @attribute_type_code,
		[attribute_type_name] = @attribute_type_name,
		[attribute_type_desc] = @attribute_type_desc,
		[attribute_data_type_key] = @attribute_data_type_key,
		[attribute_default_format] = @attribute_default_format
	WHERE [attribute_type_key] = @attribute_type_key
		AND ([attribute_type_category] <> @attribute_type_category
		OR [attribute_type_code] <> @attribute_type_code
		OR [attribute_type_name] <> @attribute_type_name
		OR [attribute_type_desc] <> @attribute_type_desc
		OR [attribute_data_type_key] <> @attribute_data_type_key
		OR [attribute_default_format] <> @attribute_default_format);
	SELECT @key = @attribute_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'attribute_type', 'usp_attribute_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_type_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_attribute_type_ups] TO [businessuser]
    AS [dbo];

