﻿/*****************************************************************
**	Table Name: person_type
**	Procedure Name: usp_person_type_all
**	Author: Richard Richards
**	Created: 06/23/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_person_type_all]
AS
SET NOCOUNT ON

SELECT [person_type_key], 
	[person_type_category], 
	[person_type_code], 
	[person_type_name], 
	[person_type_desc], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM person_type


SET NOCOUNT OFF



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_type_all] TO [RDRRL8\QIQOServiceAccount]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[usp_person_type_all] TO [businessuser]
    AS [dbo];

