CREATE TABLE [dbo].[material]
(
--DEFAULT (NEXT VALUE FOR [account_key_seq]) NOT NULL
	[material_key] INT PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR [material_key_seq]) NOT NULL, 
	[material_code] VARCHAR(10) NOT NULL, 
	[material_name] VARCHAR(50) NOT NULL,
	[material_desc] VARCHAR(250) NOT NULL,
	[active] bit DEFAULT (1) NOT NULL,
	[material_start_date]    DATETIME      NOT NULL DEFAULT (GETDATE()),
	[material_end_date]      DATETIME      NOT NULL DEFAULT (DATEADD(YY, 10, GETDATE())),
	[audit_add_user_id]     VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
	[audit_add_datetime]    DATETIME      DEFAULT (getdate()) NOT NULL,
	[audit_update_user_id]  VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
	[audit_update_datetime] DATETIME      DEFAULT (getdate()) NOT NULL
)
GO
CREATE TRIGGER [tgr_material_audit]
	ON [material]
	FOR INSERT, UPDATE
	AS
	BEGIN
		SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [material] A INNER JOIN inserted B
		ON A.material_key = B.material_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [material] A INNER JOIN inserted B
		ON A.material_key = B.material_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [material] A INNER JOIN deleted B
		ON A.material_key = B.material_key
		FOR XML RAW, ELEMENTS)

		IF (@new_xml IS NOT NULL OR @old_xml IS NOT NULL)
		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   ,[audit_data_new])
			 VALUES
				   (CASE -- WHEN @old_xml IS NULL AND @new_xml IS NULL THEN 'D' 
						WHEN @old_xml IS NULL AND @new_xml IS NOT NULL THEN 'I'
						ELSE 'U' END
				   ,'material'
				   ,'material record change'
				   ,@old_xml
				   ,@new_xml)
	END




GO
CREATE TRIGGER [tgr_material_audit_del]
	ON [material]
	AFTER DELETE
	AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @old_xml XML
		SELECT @old_xml = (SELECT B.* 
		FROM deleted B
		FOR XML RAW, ELEMENTS)

		IF (@old_xml IS NOT NULL)
		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   )
			 VALUES
				   ('D' 
				   ,'material'
				   ,'material record deleted'
				   ,@old_xml)
	END



