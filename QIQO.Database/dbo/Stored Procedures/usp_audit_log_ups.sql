



/*****************************************************************
**	Table Name: audit_log
**	Procedure Name: usp_audit_log_ups
**	Author: Richard Richards
**	Created: 07/05/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_audit_log_ups]

	@audit_log_key bigint,
	@audit_action char(1),
	@audit_bus_obj varchar(30),
	@audit_datetime datetime,
	@audit_user_id varchar(30),
	@audit_app_name varchar(150),
	@audit_host_name varchar(128),
	@audit_comment varchar(512),
	@audit_data_old xml,
	@audit_data_new xml,
	@key int out
AS
SET NOCOUNT ON
	DECLARE @new_key int;
IF @audit_log_key = 0 BEGIN
	BEGIN TRY
	SELECT @new_key = NEXT VALUE FOR audit_log_key_seq;
	INSERT INTO audit_log (audit_log_key,
		[audit_action],
		[audit_bus_obj],
		[audit_datetime],
		[audit_user_id],
		[audit_app_name],
		[audit_host_name],
		[audit_comment],
		[audit_data_old],
		[audit_data_new]
	)
	VALUES (@new_key,
		@audit_action,
		@audit_bus_obj,
		@audit_datetime,
		@audit_user_id,
		@audit_app_name,
		@audit_host_name,
		@audit_comment,
		@audit_data_old,
		@audit_data_new
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'audit_log', 'usp_audit_log_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	SELECT @new_key = NEXT VALUE FOR audit_log_key_seq;
	INSERT INTO audit_log (audit_log_key,
		[audit_action],
		[audit_bus_obj],
		[audit_datetime],
		[audit_user_id],
		[audit_app_name],
		[audit_host_name],
		[audit_comment],
		[audit_data_old],
		[audit_data_new]
	)
	VALUES (@new_key,
		@audit_action,
		@audit_bus_obj,
		@audit_datetime,
		@audit_user_id,
		@audit_app_name,
		@audit_host_name,
		@audit_comment,
		@audit_data_old,
		@audit_data_new
	)
	SELECT @key = @new_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'audit_log', 'usp_audit_log_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_audit_log_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_audit_log_ups] TO [businessuser]
    AS [dbo];

