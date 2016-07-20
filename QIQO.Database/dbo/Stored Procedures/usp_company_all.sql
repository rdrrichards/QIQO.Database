/*****************************************************************
**	Table Name: company
**	Procedure Name: usp_company_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_company_all]
AS
SET NOCOUNT ON

SELECT [company_key], 
	[company_code], 
	[company_name], 
	[company_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM company


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_company_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_company_all] TO [businessuser]
    AS [dbo];

