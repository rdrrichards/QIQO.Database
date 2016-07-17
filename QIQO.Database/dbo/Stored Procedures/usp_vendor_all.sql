/*****************************************************************
**	Table Name: vendor
**	Procedure Name: usp_vendor_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_vendor_all]
AS
SET NOCOUNT ON

SELECT [vendor_key], 
	[vendor_code], 
	[vendor_name], 
	[vendor_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM vendor


SET NOCOUNT OFF

