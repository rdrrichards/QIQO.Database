



/*****************************************************************
**	Table Name: entity_product
**	Procedure Name: usp_entity_product_ups
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_product_ups]

	@entity_product_key int,
	@product_key int,
	@product_type_key int,
	@entity_product_seq int,
	@entity_key int,
	@entity_type_key int,
	@comment varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @entity_product_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR entity_product_key_seq;
	INSERT INTO entity_product ([entity_product_key],
		[product_key],
		[product_type_key],
		[entity_product_seq],
		[entity_key],
		[entity_type_key],
		[comment]
	)
	VALUES (@new_key,
		@product_key,
		@product_type_key,
		@entity_product_seq,
		@entity_key,
		@entity_type_key,
		@comment
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_product', 'usp_entity_product_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE entity_product SET 
		[product_key] = @product_key,
		[product_type_key] = @product_type_key,
		[entity_product_seq] = @entity_product_seq,
		[entity_key] = @entity_key,
		[entity_type_key] = @entity_type_key,
		[comment] = @comment
	WHERE [entity_product_key] = @entity_product_key
		AND ([product_key] <> @product_key
		OR [product_type_key] <> @product_type_key
		OR [entity_product_seq] <> @entity_product_seq
		OR [entity_key] <> @entity_key
		OR [entity_type_key] <> @entity_type_key
		OR [comment] <> @comment);
	SELECT @key = @entity_product_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_product', 'usp_entity_product_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF





