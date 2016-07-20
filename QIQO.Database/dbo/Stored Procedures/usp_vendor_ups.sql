



/*****************************************************************
**	Table Name: vendor
**	Procedure Name: usp_vendor_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_vendor_ups]

	@vendor_key int,
	@vendor_code varchar(10),
	@vendor_name varchar(150),
	@vendor_desc varchar(255),
	@key int out
AS
SET NOCOUNT ON
IF @vendor_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR vendor_key_seq;
	INSERT INTO vendor ([vendor_key],
		[vendor_code],
		[vendor_name],
		[vendor_desc]
	)
	VALUES (@new_key,
		@vendor_code,
		@vendor_name,
		@vendor_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'vendor';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE vendor SET 
		[vendor_code] = @vendor_code,
		[vendor_name] = @vendor_name,
		[vendor_desc] = @vendor_desc
	WHERE [vendor_key] = @vendor_key
		AND ([vendor_code] <> @vendor_code
		OR [vendor_name] <> @vendor_name
		OR [vendor_desc] <> @vendor_desc);
	SELECT @key = @vendor_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'vendor';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_ups] TO [businessuser]
    AS [dbo];

