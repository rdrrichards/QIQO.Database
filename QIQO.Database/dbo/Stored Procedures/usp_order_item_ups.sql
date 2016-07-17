



/*****************************************************************
**	Table Name: order_item
**	Procedure Name: usp_order_item_ups
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_item_ups]

	@order_item_key int,
	@order_key int,
	@order_item_seq int,
	@product_key int,
	@product_name varchar(150),
	@product_desc varchar(255),
	@order_item_quantity int,
	@shipto_addr_key int,
	@billto_addr_key int,
	@order_item_ship_date datetime = null,
	@order_item_complete_date datetime = null,
	@order_item_price_per money,
	@order_item_line_sum money,
	@order_item_acct_rep_key int,
	@order_item_sales_rep_key int,
	@order_item_status_key int,
	@key int out
AS
SET NOCOUNT ON
IF @order_item_key = 0 BEGIN
	BEGIN TRY
	DECLARE @new_key int;
	SELECT @new_key = NEXT VALUE FOR order_item_key_seq;
	INSERT INTO order_item ([order_item_key],
		[order_key],
		[order_item_seq],
		[product_key],
		[product_name],
		[product_desc],
		[order_item_quantity],
		[shipto_addr_key],
		[billto_addr_key],
		[order_item_ship_date],
		[order_item_complete_date],
		[order_item_price_per],
		[order_item_line_sum],
		[order_item_acct_rep_key], 
		[order_item_sales_rep_key], 
		[order_item_status_key]
	)
	VALUES (@new_key,
		@order_key,
		@order_item_seq,
		@product_key,
		@product_name,
		@product_desc,
		@order_item_quantity,
		@shipto_addr_key,
		@billto_addr_key,
		@order_item_ship_date,
		@order_item_complete_date,
		@order_item_price_per,
		@order_item_line_sum,
		@order_item_acct_rep_key,
		@order_item_sales_rep_key,
		@order_item_status_key
	)
	SELECT @key = @new_key;
	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_item', 'usp_order_item_ups', 'I';
		THROW;
	END CATCH
END
ELSE BEGIN

	DECLARE @order_status_key int;
	SELECT @order_status_key = order_status_key FROM order_header WHERE order_key = @order_key;
	IF @order_status_key = 6 
		SELECT @order_item_complete_date = GETDATE(), @order_item_status_key = 12
	
	BEGIN TRY
	UPDATE order_item SET 
		[order_key] = @order_key,
		[order_item_seq] = @order_item_seq, --CASE WHEN @order_item_status_key <> 14 THEN @order_item_seq ELSE -@order_item_seq END,
		[product_key] = @product_key,
		[product_name] = @product_name,
		[product_desc] = @product_desc,
		[order_item_quantity] = @order_item_quantity,
		[shipto_addr_key] = @shipto_addr_key,
		[billto_addr_key] = @billto_addr_key,
		[order_item_ship_date] = @order_item_ship_date,
		[order_item_complete_date] = @order_item_complete_date,
		[order_item_price_per] = @order_item_price_per,
		[order_item_line_sum] = @order_item_line_sum,
		[order_item_acct_rep_key] = @order_item_acct_rep_key,
		[order_item_sales_rep_key] = @order_item_sales_rep_key,
		[order_item_status_key] = @order_item_status_key
	WHERE [order_item_key] = @order_item_key
		AND ([order_key] <> @order_key
		OR [order_item_seq] <> @order_item_seq
		OR [product_key] <> @product_key
		OR [product_name] <> @product_name
		OR [product_desc] <> @product_desc
		OR [order_item_quantity] <> @order_item_quantity
		OR [shipto_addr_key] <> @shipto_addr_key
		OR [billto_addr_key] <> @billto_addr_key
		OR [order_item_ship_date] <> @order_item_ship_date
		OR [order_item_complete_date] <> @order_item_complete_date
		OR [order_item_price_per] <> @order_item_price_per
		OR [order_item_line_sum] <> @order_item_line_sum
		OR [order_item_acct_rep_key] <> @order_item_acct_rep_key
		OR [order_item_sales_rep_key] <> @order_item_sales_rep_key
		OR [order_item_status_key] <> @order_item_status_key);
	SELECT @key = @order_item_key;

	END TRY
	BEGIN CATCH
		EXEC usp_LogError 'order_item', 'usp_order_item_ups', 'U';
		THROW;
	END CATCH
END

SET NOCOUNT OFF






