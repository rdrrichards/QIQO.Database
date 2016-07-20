



/*****************************************************************
**	Table Name: person
**	Procedure Name: usp_person_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_ups]

	@person_key int,
	@person_code varchar(50),
	@person_first_name varchar(50),
	@person_mi char(1),
	@person_last_name varchar(50),
	@parent_person_key int,
	@person_dob date,
	@key int out
AS
--SET NOCOUNT ON
IF @person_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR person_key_seq;
	INSERT INTO person ([person_key],
		[person_code],
		[person_first_name],
		[person_mi],
		[person_last_name],
		[parent_person_key],
		[person_dob]
	)
	VALUES (@new_key,
		@person_code,
		@person_first_name,
		@person_mi,
		@person_last_name,
		@parent_person_key,
		@person_dob
	)
	SELECT @key = @new_key; -- As InsertedID
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'person', 'usp_person_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE person SET 
		[person_code] = @person_code,
		[person_first_name] = @person_first_name,
		[person_mi] = @person_mi,
		[person_last_name] = @person_last_name,
		[parent_person_key] = @parent_person_key,
		[person_dob] = @person_dob
	WHERE [person_key] = @person_key
		AND ([person_code] <> @person_code
		OR [person_first_name] <> @person_first_name
		OR [person_mi] <> @person_mi
		OR [person_last_name] <> @person_last_name
		OR [parent_person_key] <> @parent_person_key
		OR [person_dob] <> @person_dob);

	SELECT @key = @person_key

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'person', 'usp_person_ups', 'U';
		THROW;
	END CATCH
END

--SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_ups] TO [businessuser]
    AS [dbo];

