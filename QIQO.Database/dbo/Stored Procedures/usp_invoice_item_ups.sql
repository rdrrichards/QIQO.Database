



/*****************************************************************
**	Table Name: invoice_item
**	Procedure Name: usp_invoice_item_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_item_ups]

	@invoice_item_key int,
	@invoice_key int,
	@invoice_item_seq int,
	@product_key int,
	@product_name varchar(150),
	@product_desc varchar(255),
	@invoice_item_quantity int,
	@shipto_addr_key int,
	@billto_addr_key int,
	@invoice_item_entry_date datetime,
	@order_item_ship_date datetime = null,
	@invoice_item_complete_date datetime = null,
	@invoice_item_price_per money,
	@invoice_item_line_sum money,
	@invoice_item_account_rep_key int,
	@invoice_item_sales_rep_key int,
	@invoice_item_status_key int,
	@order_item_key int,
	@key int out
AS
SET NOCOUNT ON
IF @invoice_item_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR invoice_item_key_seq;
	INSERT INTO invoice_item ([invoice_item_key],
		[invoice_key],
		[invoice_item_seq],
		[product_key],
		[product_name],
		[product_desc],
		[invoice_item_quantity],
		[shipto_addr_key],
		[billto_addr_key],
		[invoice_item_entry_date],
		[order_item_ship_date],
		[invoice_item_complete_date],
		[invoice_item_price_per],
		[invoice_item_line_sum],
		[invoice_item_account_rep_key],
		[invoice_item_sales_rep_key],
		[invoice_item_status_key],
		[order_item_key]
	)
	VALUES (@new_key,
		@invoice_key,
		@invoice_item_seq,
		@product_key,
		@product_name,
		@product_desc,
		@invoice_item_quantity,
		@shipto_addr_key,
		@billto_addr_key,
		@invoice_item_entry_date,
		@order_item_ship_date,
		@invoice_item_complete_date,
		@invoice_item_price_per,
		@invoice_item_line_sum,
		@invoice_item_account_rep_key,
		@invoice_item_sales_rep_key,
		@invoice_item_status_key,
		@order_item_key
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice_item', 'usp_invoice_item_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN
	BEGIN TRY
	UPDATE invoice_item SET 
		[invoice_key] = @invoice_key,
		[invoice_item_seq] = @invoice_item_seq,
		[product_key] = @product_key,
		[product_name] = @product_name,
		[product_desc] = @product_desc,
		[invoice_item_quantity] = @invoice_item_quantity,
		[shipto_addr_key] = @shipto_addr_key,
		[billto_addr_key] = @billto_addr_key,
		[invoice_item_entry_date] = @invoice_item_entry_date,
		[order_item_ship_date] = @order_item_ship_date,
		[invoice_item_complete_date] = @invoice_item_complete_date,
		[invoice_item_price_per] = @invoice_item_price_per,
		[invoice_item_line_sum] = @invoice_item_line_sum,
		[invoice_item_account_rep_key] = @invoice_item_account_rep_key,
		[invoice_item_sales_rep_key] = @invoice_item_sales_rep_key,
		[invoice_item_status_key] = @invoice_item_status_key,
		[order_item_key] = @order_item_key
	WHERE [invoice_item_key] = @invoice_item_key
		AND ([invoice_key] <> @invoice_key
		OR [invoice_item_seq] <> @invoice_item_seq
		OR [product_key] <> @product_key
		OR [product_name] <> @product_name
		OR [product_desc] <> @product_desc
		OR [invoice_item_quantity] <> @invoice_item_quantity
		OR [shipto_addr_key] <> @shipto_addr_key
		OR [billto_addr_key] <> @billto_addr_key
		OR [invoice_item_entry_date] <> @invoice_item_entry_date
		OR [order_item_ship_date] <> @order_item_ship_date
		OR [invoice_item_complete_date] <> @invoice_item_complete_date
		OR [invoice_item_price_per] <> @invoice_item_price_per
		OR [invoice_item_line_sum] <> @invoice_item_line_sum
		OR [invoice_item_account_rep_key] <> @invoice_item_account_rep_key
		OR [invoice_item_sales_rep_key] <> @invoice_item_sales_rep_key
		OR [invoice_item_status_key] <> @invoice_item_status_key
		OR [order_item_key] <> @order_item_key);
	SELECT @key = @invoice_item_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'invoice_item', 'usp_invoice_item_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_ups] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_item_ups] TO [businessuser]
    AS [dbo];

