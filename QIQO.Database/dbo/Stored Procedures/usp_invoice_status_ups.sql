



/*****************************************************************
**	Table Name: invoice_status
**	Procedure Name: usp_invoice_status_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_status_ups]

	@invoice_status_key int,
	@invoice_status_code varchar(10),
	@invoice_status_name varchar(50),
	@invoice_status_type varchar(50),
	@invoice_status_desc varchar(255),
	@key int out
AS
SET NOCOUNT ON
IF @invoice_status_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR invoice_status_key_seq;
	INSERT INTO invoice_status ([invoice_status_key],
		[invoice_status_code],
		[invoice_status_name],
		[invoice_status_type],
		[invoice_status_desc]
	)
	VALUES (@new_key,
		@invoice_status_code,
		@invoice_status_name,
		@invoice_status_type,
		@invoice_status_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice_status', 'usp_invoice_status_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE invoice_status SET 
		[invoice_status_code] = @invoice_status_code,
		[invoice_status_name] = @invoice_status_name,
		[invoice_status_type] = @invoice_status_type,
		[invoice_status_desc] = @invoice_status_desc
	WHERE [invoice_status_key] = @invoice_status_key
		AND ([invoice_status_code] <> @invoice_status_code
		OR [invoice_status_name] <> @invoice_status_name
		OR [invoice_status_type] <> @invoice_status_type
		OR [invoice_status_desc] <> @invoice_status_desc);
	SELECT @key = @invoice_status_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice_status', 'usp_invoice_status_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_status_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_status_ups] TO [businessuser]
    AS [dbo];

