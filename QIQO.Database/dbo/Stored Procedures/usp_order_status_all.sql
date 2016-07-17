/*****************************************************************
**	Table Name: order_status
**	Procedure Name: usp_order_status_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_order_status_all]
AS
SET NOCOUNT ON

SELECT [order_status_key], 
	[order_status_code], 
	[order_status_name], 
	[order_status_type], 
	[order_status_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM order_status


SET NOCOUNT OFF


