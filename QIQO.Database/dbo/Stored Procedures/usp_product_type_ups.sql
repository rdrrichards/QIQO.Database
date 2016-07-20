



/*****************************************************************
**	Table Name: product_type
**	Procedure Name: usp_product_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_product_type_ups]

	@product_type_key int,
	@product_type_category varchar(50),
	@product_type_code varchar(10),
	@product_type_name varchar(50),
	@product_type_desc varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @product_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR product_type_key_seq;
	INSERT INTO product_type ([product_type_key],
		[product_type_category],
		[product_type_code],
		[product_type_name],
		[product_type_desc]
	)
	VALUES (@new_key,
		@product_type_category,
		@product_type_code,
		@product_type_name,
		@product_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'product_type', 'usp_product_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE product_type SET 
		[product_type_category] = @product_type_category,
		[product_type_code] = @product_type_code,
		[product_type_name] = @product_type_name,
		[product_type_desc] = @product_type_desc
	WHERE [product_type_key] = @product_type_key
		AND ([product_type_category] <> @product_type_category
		OR [product_type_code] <> @product_type_code
		OR [product_type_name] <> @product_type_name
		OR [product_type_desc] <> @product_type_desc);
	SELECT @key = @product_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'product_type', 'usp_product_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_type_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_product_type_ups] TO [businessuser]
    AS [dbo];

