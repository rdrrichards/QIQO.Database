CREATE TABLE [dbo].[invoice] (
    [invoice_key]           INT          CONSTRAINT [DF__invoice__invoice__37703C52] DEFAULT (NEXT VALUE FOR [invoice_key_seq]) NOT NULL,
    [from_entity_key]       INT          NULL,
    [account_key]           INT          NOT NULL,
    [account_contact_key]   INT          NOT NULL,
    [invoice_num]           VARCHAR (15) NULL,
    [invoice_entry_date]    DATETIME     NOT NULL,
    [order_entry_date]      DATETIME     NOT NULL,
    [invoice_status_key]    INT          NOT NULL,
    [invoice_status_date]   DATETIME     NOT NULL,
    [order_ship_date]       DATETIME     NULL,
    [account_rep_key]       INT          NULL,
    [sales_rep_key]         INT          NULL,
    [invoice_complete_date] DATETIME     NULL,
    [invoice_value_sum]     MONEY        NULL,
    [invoice_item_count]    INT          NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__invoice__audit_a__2116E6DF] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__invoice__audit_a__220B0B18] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__invoice__audit_u__22FF2F51] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__invoice__audit_u__23F3538A] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__invoice__BAD53B1127FC51B2] PRIMARY KEY CLUSTERED ([invoice_key] ASC),
    CONSTRAINT [FK_invoice_account] FOREIGN KEY ([account_key]) REFERENCES [dbo].[account] ([account_key]),
    CONSTRAINT [FK_invoice_invoice_status] FOREIGN KEY ([invoice_status_key]) REFERENCES [dbo].[invoice_status] ([invoice_status_key])
);


GO
CREATE TRIGGER [tgr_invoice_audit]
    ON dbo.invoice
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [invoice] A INNER JOIN inserted B
		ON A.invoice_key = B.invoice_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [invoice] A INNER JOIN inserted B
		ON A.invoice_key = B.invoice_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [invoice] A INNER JOIN deleted B
		ON A.invoice_key = B.invoice_key
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
				   ,'invoice'
				   ,'invoice'
				   ,@old_xml
				   ,@new_xml)

    END

GO
CREATE TRIGGER [tgr_invoice_audit_del]
    ON dbo.invoice
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
				   ,'invoice'
				   ,'invoice record deleted'
				   ,@old_xml)

    END
