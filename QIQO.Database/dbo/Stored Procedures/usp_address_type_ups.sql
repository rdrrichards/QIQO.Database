



/*****************************************************************
**	Table Name: address_type
**	Procedure Name: usp_address_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_address_type_ups]

	@address_type_key int,
	@address_type_code varchar(10),
	@address_type_name varchar(50),
	@address_type_desc varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @address_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR address_type_key_seq;
	INSERT INTO address_type ([address_type_key],
		[address_type_code],
		[address_type_name],
		[address_type_desc]
	)
	VALUES (@new_key,
		@address_type_code,
		@address_type_name,
		@address_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'address_type', 'usp_address_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE address_type SET 
		[address_type_code] = @address_type_code,
		[address_type_name] = @address_type_name,
		[address_type_desc] = @address_type_desc
	WHERE [address_type_key] = @address_type_key
		AND ([address_type_code] <> @address_type_code
		OR [address_type_name] <> @address_type_name
		OR [address_type_desc] <> @address_type_desc);
	SELECT @key = @address_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'address_type', 'usp_address_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






