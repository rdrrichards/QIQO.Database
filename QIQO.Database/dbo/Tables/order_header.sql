CREATE TABLE [dbo].[order_header] (
    [order_key]             INT          CONSTRAINT [DF__order_hea__order__4B7734FF] DEFAULT (NEXT VALUE FOR [order_header_key_seq]) NOT NULL,
    [account_key]           INT          NOT NULL,
    [account_contact_key]   INT          NOT NULL,
    [order_num]             VARCHAR (15) NULL,
    [order_entry_date]      DATETIME     NOT NULL,
    [order_status_key]      INT          NOT NULL,
    [order_status_date]     DATETIME     NOT NULL,
    [order_ship_date]       DATETIME     NULL,
    [account_rep_key]       INT          NULL,
    [order_complete_date]   DATETIME     NULL,
    [order_value_sum]       MONEY        NULL,
    [order_item_count]      INT          NULL,
    [deliver_by_date]       DATETIME     NULL,
    [sales_rep_key]         INT          NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__order_hea__audit__0C85DE4D] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__order_hea__audit__0D7A0286] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__order_hea__audit__0E6E26BF] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__order_hea__audit__0F624AF8] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__order_he__843186A08F9FB416] PRIMARY KEY CLUSTERED ([order_key] ASC),
    CONSTRAINT [FK_order_header_account] FOREIGN KEY ([account_key]) REFERENCES [dbo].[account] ([account_key]),
    CONSTRAINT [FK_order_header_order_status] FOREIGN KEY ([order_status_key]) REFERENCES [dbo].[order_status] ([order_status_key])
);


GO
CREATE TRIGGER [tgr_order_header_audit]
    ON [order_header]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [order_header] A INNER JOIN inserted B
		ON A.order_key = B.order_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [order_header] A INNER JOIN inserted B
		ON A.order_key = B.order_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [order_header] A INNER JOIN deleted B
		ON A.order_key = B.order_key
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
				   ,'order_header'
				   ,'order_header'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_order_header_audit_del]
    ON [order_header]
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
				   ,'order_header'
				   ,'order_header record deleted'
				   ,@old_xml)

    END

