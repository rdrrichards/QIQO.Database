﻿
/*****************************************************************
**	Table Name: fee_schedule
**	Procedure Name: usp_fee_schedule_all
**	Author: Richard Richards
**	Created: 07/15/2015
**	Copyright: QIQO Software, (c) 2015
******************************************************************/

CREATE PROC [dbo].[usp_fee_schedule_all_by_company]
	@company_key int
AS
SET NOCOUNT ON

SELECT [fee_schedule_key], 
	[company_key], 
	[account_key], 
	[product_key], 
	[fee_schedule_start_date], 
	[fee_schedule_end_date], 
	[fee_schedule_type], 
	[fee_schedule_value], 
	[audit_add_user_id], 
	[audit_add_datetime], 
	[audit_update_user_id], 
	[audit_update_datetime]
FROM fee_schedule A
WHERE A.company_key = @company_key


SET NOCOUNT OFF


