/*****************************************************************
**	Table Name: order_header
**	Procedure Name: usp_order_header_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_header_all]
AS
SET NOCOUNT ON

SELECT [order_key], 
	[account_key], 
	order_num,
	[account_contact_key], 
	[order_entry_date], 
	[order_status_key], 
	[order_status_date], 
	[order_ship_date], 
	[account_rep_key], 
	[order_complete_date], 
	[order_value_sum], 
	[order_item_count], 
	[deliver_by_date],
	[sales_rep_key],
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM order_header


SET NOCOUNT OFF


