


/*****************************************************************
**	Table Name: invoice
**	Procedure Name: usp_invoice_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_ups]

	@invoice_key int,
	@from_entity_key int,
	@account_key int,
	@account_contact_key int,
	@invoice_num varchar(15),
	@invoice_entry_date datetime,
	@order_entry_date datetime = null,
	@invoice_status_key int,
	@invoice_status_date datetime = null,
	@order_ship_date datetime = null,
	@account_rep_key int,
	@sales_rep_key int,
	@invoice_complete_date datetime = null,
	@invoice_value_sum money,
	@invoice_item_count int,
	@key int out
AS
SET NOCOUNT ON
IF @invoice_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR invoice_key_seq;
	INSERT INTO invoice ([invoice_key],
		[from_entity_key],
		[account_key],
		[account_contact_key],
		[invoice_num],
		[invoice_entry_date],
		[order_entry_date],
		[invoice_status_key],
		[invoice_status_date],
		[order_ship_date],
		[account_rep_key],
		[sales_rep_key],
		[invoice_complete_date],
		[invoice_value_sum],
		[invoice_item_count]
	)
	VALUES (@new_key,
		@from_entity_key,
		@account_key,
		@account_contact_key,
		@invoice_num,
		@invoice_entry_date,
		@order_entry_date,
		@invoice_status_key,
		@invoice_status_date,
		@order_ship_date,
		@account_rep_key,
		@sales_rep_key,
		@invoice_complete_date,
		@invoice_value_sum,
		@invoice_item_count
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice', 'usp_invoice_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE invoice SET 
		[from_entity_key] = @from_entity_key,
		[account_key] = @account_key,
		[account_contact_key] = @account_contact_key,
		[invoice_num] = @invoice_num,
		[invoice_entry_date] = @invoice_entry_date,
		[order_entry_date] = @order_entry_date,
		[invoice_status_key] = @invoice_status_key,
		[invoice_status_date] = @invoice_status_date,
		[order_ship_date] = @order_ship_date,
		[account_rep_key] = @account_rep_key,
		[sales_rep_key] = @sales_rep_key,
		[invoice_complete_date] = @invoice_complete_date,
		[invoice_value_sum] = @invoice_value_sum,
		[invoice_item_count] = @invoice_item_count
	WHERE [invoice_key] = @invoice_key
		AND ([from_entity_key] <> @from_entity_key
		OR [account_key] <> @account_key
		OR [account_contact_key] <> @account_contact_key
		OR [invoice_num] <> @invoice_num
		OR [invoice_entry_date] <> @invoice_entry_date
		OR [order_entry_date] <> @order_entry_date
		OR [invoice_status_key] <> @invoice_status_key
		OR [invoice_status_date] <> @invoice_status_date
		OR [order_ship_date] <> @order_ship_date
		OR [account_rep_key] <> @account_rep_key
		OR [sales_rep_key] <> @sales_rep_key
		OR [invoice_complete_date] <> @invoice_complete_date
		OR [invoice_value_sum] <> @invoice_value_sum
		OR [invoice_item_count] <> @invoice_item_count);
	SELECT @key = @invoice_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice', 'usp_invoice_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_ups] TO [businessuser]
    AS [dbo];

