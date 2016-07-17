CREATE TABLE [dbo].[invoice_status] (
    [invoice_status_key]    INT           DEFAULT (NEXT VALUE FOR [invoice_status_key_seq]) NOT NULL,
    [invoice_status_code]   VARCHAR (10)  NOT NULL,
    [invoice_status_name]   VARCHAR (50)  NOT NULL,
    [invoice_status_type]   VARCHAR (50)  NOT NULL,
    [invoice_status_desc]   VARCHAR (255) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([invoice_status_key] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150704-170648]
    ON [dbo].[invoice_status]([invoice_status_code] ASC, [invoice_status_name] ASC, [invoice_status_type] ASC);


GO

CREATE TRIGGER [tgr_invoice_status_audit]
    ON [invoice_status]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [invoice_status] A INNER JOIN inserted B
		ON A.invoice_status_key = B.invoice_status_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [invoice_status] A INNER JOIN inserted B
		ON A.invoice_status_key = B.invoice_status_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [invoice_status] A INNER JOIN deleted B
		ON A.invoice_status_key = B.invoice_status_key
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
				   ,'invoice_status'
				   ,'invoice_status'
				   ,@old_xml
				   ,@new_xml)

    END




GO

CREATE TRIGGER [tgr_invoice_status_audit_del]
    ON [invoice_status]
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
				   ,'invoice_status'
				   ,'invoice_status record deleted'
				   ,@old_xml)

    END



