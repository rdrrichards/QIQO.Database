
/*****************************************************************
**	Table Name: entity_person
**	Procedure Name: usp_entity_person_ups_emp_rel
**	Author: Richard Richards
**	Created: 03/11/2016
**	Copyright: QIQO Software, (c) 2016
******************************************************************/

CREATE PROC [dbo].[usp_entity_person_ups_emp_rel]
	@person_key int,
	@entity_key int,
	@entity_type_key int, -- 12 will give you the manager, 13 will give you a coworker
	@key int out
AS
SET NOCOUNT ON

IF EXISTS (SELECT *
	FROM entity_person A 
	WHERE A.person_key = @person_key
	AND A.entity_type_key = @entity_type_key
	AND GETDATE() BETWEEN [start_date] AND [end_date])
BEGIN
	BEGIN TRY
	UPDATE entity_person SET
		entity_key = @entity_key
	WHERE person_key = @person_key
	AND entity_type_key = @entity_type_key
	AND GETDATE() BETWEEN [start_date] AND [end_date]
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_ups_emp_rel', 'U';
		THROW;
	END CATCH
END 
ELSE BEGIN
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
		2, -- it will ALWAYS be a person to person type of relationship
		'Employee',
		@entity_key,
		@entity_type_key,
		'Employee -> Manager Relationship', GETDATE(), DATEADD(YY, 10, GETDATE())
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'entity_person', 'usp_entity_person_ups_emp_rel', 'I';
		THROW;
	END CATCH
END

SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_ups_emp_rel] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_entity_person_ups_emp_rel] TO [businessuser]
    AS [dbo];

