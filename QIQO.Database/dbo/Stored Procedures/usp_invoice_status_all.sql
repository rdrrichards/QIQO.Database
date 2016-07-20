/*****************************************************************
**	Table Name: invoice_status
**	Procedure Name: usp_invoice_status_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_invoice_status_all]
AS
SET NOCOUNT ON

SELECT [invoice_status_key], 
	[invoice_status_code], 
	[invoice_status_name], 
	[invoice_status_type], 
	[invoice_status_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM invoice_status


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_status_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_invoice_status_all] TO [businessuser]
    AS [dbo];

