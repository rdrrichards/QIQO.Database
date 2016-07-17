



/*****************************************************************
**	Table Name: contact
**	Procedure Name: usp_contact_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_contact_ups]

	@contact_key int,
	@entity_key int,
	@entity_type_key int,
	@contact_type_key int,
	@contact_value varchar(150),
	@contact_default_flg bit,
	@contact_active_flg bit,
	@key int out
AS
SET NOCOUNT ON
IF @contact_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR contact_key_seq;
	INSERT INTO contact ([contact_key],
		[entity_key],
		[entity_type_key],
		[contact_type_key],
		[contact_value],
		[contact_default_flg],
		[contact_active_flg]
	)
	VALUES (@new_key,
		@entity_key,
		@entity_type_key,
		@contact_type_key,
		@contact_value,
		@contact_default_flg,
		@contact_active_flg
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'contact', 'usp_contact_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE contact SET 
		[entity_key] = @entity_key,
		[entity_type_key] = @entity_type_key,
		[contact_type_key] = @contact_type_key,
		[contact_value] = @contact_value,
		[contact_default_flg] = @contact_default_flg,
		[contact_active_flg] = @contact_active_flg
	WHERE [contact_key] = @contact_key
		AND ([entity_key] <> @entity_key
		OR [entity_type_key] <> @entity_type_key
		OR [contact_type_key] <> @contact_type_key
		OR [contact_value] <> @contact_value
		OR [contact_default_flg] <> @contact_default_flg
		OR [contact_active_flg] <> @contact_active_flg);
	SELECT @key = @contact_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'contact', 'usp_contact_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






