



/*****************************************************************
**	Table Name: comment_type
**	Procedure Name: usp_comment_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_comment_type_ups]

	@comment_type_key int,
	@comment_type_category varchar(50),
	@comment_type_code varchar(10),
	@comment_type_name varchar(50),
	@comment_type_desc varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @comment_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR comment_type_key_seq;
	INSERT INTO comment_type ([comment_type_key],
		[comment_type_category],
		[comment_type_code],
		[comment_type_name],
		[comment_type_desc]
	)
	VALUES (@new_key,
		@comment_type_category,
		@comment_type_code,
		@comment_type_name,
		@comment_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'comment_type', 'usp_comment_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE comment_type SET 
		[comment_type_category] = @comment_type_category,
		[comment_type_code] = @comment_type_code,
		[comment_type_name] = @comment_type_name,
		[comment_type_desc] = @comment_type_desc
	WHERE [comment_type_key] = @comment_type_key
		AND ([comment_type_category] <> @comment_type_category
		OR [comment_type_code] <> @comment_type_code
		OR [comment_type_name] <> @comment_type_name
		OR [comment_type_desc] <> @comment_type_desc);
	SELECT @key = @comment_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'comment_type', 'usp_comment_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






