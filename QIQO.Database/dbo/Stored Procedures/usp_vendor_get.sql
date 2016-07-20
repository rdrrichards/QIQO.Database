﻿/*****************************************************************
**	Table Name: vendor
**	Procedure Name: usp_vendor_get
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_vendor_get]
	@vendor_key int
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
WHERE [vendor_key] = @vendor_key


SET NOCOUNT OFF


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_get] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_vendor_get] TO [businessuser]
    AS [dbo];

