



/*****************************************************************
**	Table Name: person_type
**	Procedure Name: usp_person_type_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_type_ups]

	@person_type_key int,
	@person_type_category varchar(50),
	@person_type_code varchar(10),
	@person_type_name varchar(50),
	@person_type_desc varchar(150),
	@key int out
AS
SET NOCOUNT ON
IF @person_type_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR person_type_key_seq;
	INSERT INTO person_type ([person_type_key],
		[person_type_category],
		[person_type_code],
		[person_type_name],
		[person_type_desc]
	)
	VALUES (@new_key,
		@person_type_category,
		@person_type_code,
		@person_type_name,
		@person_type_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'person_type', 'usp_person_type_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE person_type SET 
		[person_type_category] = @person_type_category,
		[person_type_code] = @person_type_code,
		[person_type_name] = @person_type_name,
		[person_type_desc] = @person_type_desc
	WHERE [person_type_key] = @person_type_key
		AND ([person_type_category] <> @person_type_category
		OR [person_type_code] <> @person_type_code
		OR [person_type_name] <> @person_type_name
		OR [person_type_desc] <> @person_type_desc);
	SELECT @key = @person_type_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'person_type', 'usp_person_type_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






