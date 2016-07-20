



/*****************************************************************
**	Table Name: contact_type
**	Procedure Name: usp_contact_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_contact_type_ups]

	@contact_type_key int,
	@contact_type_category varchar(50),
	@contact_type_code varchar(10),
	@contact_type_name varchar(50),
	@contact_type_desc varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @contact_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR contact_type_key_seq;
	INSERT INTO contact_type ([contact_type_key],
		[contact_type_category],
		[contact_type_code],
		[contact_type_name],
		[contact_type_desc]
	)
	VALUES (@new_key,
		@contact_type_category,
		@contact_type_code,
		@contact_type_name,
		@contact_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'contact_type', 'usp_contact_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE contact_type SET 
		[contact_type_category] = @contact_type_category,
		[contact_type_code] = @contact_type_code,
		[contact_type_name] = @contact_type_name,
		[contact_type_desc] = @contact_type_desc
	WHERE [contact_type_key] = @contact_type_key
		AND ([contact_type_category] <> @contact_type_category
		OR [contact_type_code] <> @contact_type_code
		OR [contact_type_name] <> @contact_type_name
		OR [contact_type_desc] <> @contact_type_desc);
	SELECT @key = @contact_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'contact_type', 'usp_contact_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_contact_type_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_contact_type_ups] TO [businessuser]
    AS [dbo];

