CREATE TABLE [dbo].[vendor] (
    [vendor_key]            INT           DEFAULT (NEXT VALUE FOR [vendor_key_seq]) NOT NULL,
    [vendor_code]           VARCHAR (10)  NOT NULL,
    [vendor_name]           VARCHAR (150) NOT NULL,
    [vendor_desc]           VARCHAR (255) NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__vendor__audit_ad__71D1E811] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__vendor__audit_ad__72C60C4A] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__vendor__audit_up__73BA3083] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__vendor__audit_up__74AE54BC] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__vendor__E01BCD9D597F77DB] PRIMARY KEY CLUSTERED ([vendor_key] ASC)
);


GO
CREATE TRIGGER [tgr_vendor_audit]
    ON [vendor]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [vendor] A INNER JOIN inserted B
		ON A.vendor_key = B.vendor_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [vendor] A INNER JOIN inserted B
		ON A.vendor_key = B.vendor_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [vendor] A INNER JOIN deleted B
		ON A.vendor_key = B.vendor_key
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
				   ,'vendor'
				   ,'vendor'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_vendor_audit_del]
    ON [vendor]
    AFTER DELETE
    AS
    BEGIN
        SET NOCOUNT ON
		DECLARE @old_xml XML
		SELECT @old_xml = (SELECT B.* 
		FROM deleted B
		FOR XML RAW, ELEMENTS)

		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   )
			 VALUES
				   ('D' 
				   ,'vendor'
				   ,'vendor record deleted'
				   ,@old_xml)

    END



