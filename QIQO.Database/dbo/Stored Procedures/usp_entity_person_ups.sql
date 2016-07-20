



/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_ups]

	@entity_person_key int,
	@person_key int,
	@person_type_key int,
	@person_role varchar(50),
	@entity_key int,
	@entity_type_key int,
	@comment varchar(150),
	@start_date datetime,
	@end_date datetime,
	@key int out
AS
SET NOCOUNT ON
IF @entity_person_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR entity_person_key_seq;
	INSERT INTO entity_person ([entity_person_key],
		[person_key],
		[person_type_key],
		[person_role],
		[entity_key],
		[entity_type_key],
		[comment],
		[start_date],
		[end_date]
	)
	VALUES (@new_key,
		@person_key,
		@person_type_key,
		@person_role,
		@entity_key,
		@entity_type_key,
		@comment, @start_date, @end_date
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE entity_person SET 
		[person_key] = @person_key,
		[person_type_key] = @person_type_key,
		[person_role] = @person_role,
		[entity_key] = @entity_key,
		[entity_type_key] = @entity_type_key,
		[comment] = @comment,
		[start_date] = @start_date,
		[end_date] = @end_date
	WHERE [entity_person_key] = @entity_person_key
		AND ([person_key] <> @person_key
		OR [person_type_key] <> @person_type_key
		OR [person_role] <> @person_role
		OR [entity_key] <> @entity_key
		OR [entity_type_key] <> @entity_type_key
		OR [comment] <> @comment
		OR [start_date] <> @start_date
		OR [end_date] <> @end_date);
	SELECT @key = @entity_person_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_ups] TO [businessuser]
    AS [dbo];

