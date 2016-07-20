



/*****************************************************************
**	Table Name: comment
**	Procedure Name: usp_comment_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_ups]

	@comment_key int,
	@entity_key int,
	@entity_type int,
	@comment_type_key int,
	@comment_value varchar(MAX),
	@key int out
AS
SET NOCOUNT ON
IF @comment_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR comment_key_seq;
	INSERT INTO comment ([comment_key],
		[entity_key],
		[entity_type],
		[comment_type_key],
		[comment_value]
	)
	VALUES (@new_key,
		@entity_key,
		@entity_type,
		@comment_type_key,
		@comment_value
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'comment', 'usp_comment_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE comment SET 
		[entity_key] = @entity_key,
		[entity_type] = @entity_type,
		[comment_type_key] = @comment_type_key,
		[comment_value] = @comment_value
	WHERE [comment_key] = @comment_key
		AND ([entity_key] <> @entity_key
		OR [entity_type] <> @entity_type
		OR [comment_type_key] <> @comment_type_key
		OR [comment_value] <> @comment_value);
	SELECT @key = @comment_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'comment', 'usp_comment_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_comment_ups] TO [businessuser]
    AS [dbo];

