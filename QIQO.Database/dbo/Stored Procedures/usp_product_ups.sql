



/*****************************************************************
**	Table Name: product
**	Procedure Name: usp_product_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_product_ups]

	@product_key int,
	@product_type_key int,
	@product_code varchar(20),
	@product_name varchar(150),
	@product_desc varchar(255),
	@product_name_short varchar(50),
	@product_name_long varchar(255),
	@product_image_path varchar(255),
	@key int out
AS
SET NOCOUNT ON
IF @product_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR product_key_seq;
	INSERT INTO product ([product_key],
		[product_type_key],
		[product_code],
		[product_name],
		[product_desc],
		[product_name_short],
		[product_name_long],
		[product_image_path]
	)
	VALUES (@new_key,
		@product_type_key,
		@product_code,
		@product_name,
		@product_desc,
		@product_name_short,
		@product_name_long,
		@product_image_path
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'product', 'usp_product_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE product SET 
		[product_type_key] = @product_type_key,
		[product_code] = @product_code,
		[product_name] = @product_name,
		[product_desc] = @product_desc,
		[product_name_short] = @product_name_short,
		[product_name_long] = @product_name_long,
		[product_image_path] = @product_image_path
	WHERE [product_key] = @product_key
		AND ([product_type_key] <> @product_type_key
		OR [product_code] <> @product_code
		OR [product_name] <> @product_name
		OR [product_desc] <> @product_desc
		OR [product_name_short] <> @product_name_short
		OR [product_name_long] <> @product_name_long
		OR [product_image_path] <> @product_image_path);
	SELECT @key = @product_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'product', 'usp_product_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_ups] TO [businessuser]
    AS [dbo];

