



/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_ups]

	@order_key int,
	@account_key int,
	@account_contact_key int,
	@order_num varchar(15),
	@order_entry_date datetime,
	@order_status_key int,
	@order_status_date datetime,
	@order_ship_date datetime = null,
	@account_rep_key int,
	@order_complete_date datetime = null,
	@order_value_sum money,
	@order_item_count int,
	@deliver_by_date datetime = null,
	@sales_rep_key int,
	@key int out
AS
SET NOCOUNT ON
IF @order_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR order_header_key_seq;
	INSERT INTO order_header ([order_key],
		[account_key],
		[account_contact_key],
		[order_num],
		[order_entry_date],
		[order_status_key],
		[order_status_date],
		[order_ship_date],
		[account_rep_key],
		[order_complete_date],
		[order_value_sum],
		[order_item_count],
		[deliver_by_date],
		[sales_rep_key]
	)
	VALUES (@new_key,
		@account_key,
		@account_contact_key,
		@order_num,
		GETDATE(),
		@order_status_key,
		@order_status_date,
		@order_ship_date,
		@account_rep_key,
		@order_complete_date,
		@order_value_sum,
		@order_item_count,
		@deliver_by_date,
		@sales_rep_key
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_header', 'usp_order_header_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE order_header SET 
		[account_key] = @account_key,
		[account_contact_key] = @account_contact_key,
		[order_num] = @order_num,
		--[order_entry_date] = @order_entry_date,
		[order_status_key] = @order_status_key,
		[order_status_date] = @order_status_date,
		[order_ship_date] = @order_ship_date,
		[account_rep_key] = @account_rep_key,
		[order_complete_date] = IIF(@order_complete_date IS NULL AND @order_status_key = 6, GETDATE(), @order_complete_date),
		[order_value_sum] = @order_value_sum,
		[order_item_count] = @order_item_count,
		[deliver_by_date] = @deliver_by_date,
		[sales_rep_key] = @sales_rep_key
	WHERE [order_key] = @order_key
		AND ([account_key] <> @account_key
		OR [account_contact_key] <> @account_contact_key
		OR [order_num] <> @order_num
		--OR [order_entry_date] <> @order_entry_date
		OR [order_status_key] <> @order_status_key
		OR [order_status_date] <> @order_status_date
		OR [order_ship_date] <> @order_ship_date
		OR [account_rep_key] <> @account_rep_key
		OR [order_complete_date] <> @order_complete_date
		OR [order_value_sum] <> @order_value_sum
		OR [order_item_count] <> @order_item_count
		OR [deliver_by_date] <> @deliver_by_date
		OR [sales_rep_key] <> @sales_rep_key);
	SELECT @key = @order_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_header', 'usp_order_header_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_order_header_ups] TO [businessuser]
    AS [dbo];

