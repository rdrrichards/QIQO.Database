



/*****************************************************************
**	Table Name: order_status
**	Procedure Name: usp_order_status_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_status_ups]

	@order_status_key int,
	@order_status_code varchar(10),
	@order_status_name varchar(50),
	@order_status_type varchar(50),
	@order_status_desc varchar(255),
	@key int out
AS
SET NOCOUNT ON
IF @order_status_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR order_status_key_seq;
	INSERT INTO order_status ([order_status_key],
		[order_status_code],
		[order_status_name],
		[order_status_type],
		[order_status_desc]
	)
	VALUES (@new_key,
		@order_status_code,
		@order_status_name,
		@order_status_type,
		@order_status_desc
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_status', 'usp_order_status_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE order_status SET 
		[order_status_code] = @order_status_code,
		[order_status_name] = @order_status_name,
		[order_status_type] = @order_status_type,
		[order_status_desc] = @order_status_desc
	WHERE [order_status_key] = @order_status_key
		AND ([order_status_code] <> @order_status_code
		OR [order_status_name] <> @order_status_name
		OR [order_status_type] <> @order_status_type
		OR [order_status_desc] <> @order_status_desc);
	SELECT @key = @order_status_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_status', 'usp_order_status_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






