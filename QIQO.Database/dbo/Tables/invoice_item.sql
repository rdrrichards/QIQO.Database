CREATE TABLE [dbo].[invoice_item] (
    [invoice_item_key]             INT           CONSTRAINT [DF__invoice_i__invoi__3E1D39E1] DEFAULT (NEXT VALUE FOR [invoice_item_key_seq]) NOT NULL,
    [invoice_key]                  INT           NOT NULL,
    [invoice_item_seq]             INT           CONSTRAINT [DF_invoice_item_invoice_item_seq] DEFAULT ((1)) NOT NULL,
    [product_key]                  INT           NOT NULL,
    [product_name]                 VARCHAR (150) NULL,
    [product_desc]                 VARCHAR (255) NULL,
    [invoice_item_quantity]        INT           NOT NULL,
    [shipto_addr_key]              INT           NOT NULL,
    [billto_addr_key]              INT           NOT NULL,
    [invoice_item_entry_date]      DATETIME      NULL,
    [order_item_ship_date]         DATETIME      NULL,
    [invoice_item_complete_date]   DATETIME      NULL,
    [invoice_item_price_per]       MONEY         NOT NULL,
    [invoice_item_line_sum]        MONEY         NOT NULL,
    [invoice_item_account_rep_key] INT           NULL,
    [invoice_item_sales_rep_key]   INT           NULL,
    [invoice_item_status_key]      INT           NOT NULL,
    [order_item_key]               INT           NULL,
    [audit_add_user_id]            VARCHAR (30)  CONSTRAINT [DF__invoice_i__audit__27C3E46E] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]           DATETIME      CONSTRAINT [DF__invoice_i__audit__28B808A7] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]         VARCHAR (30)  CONSTRAINT [DF__invoice_i__audit__29AC2CE0] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]        DATETIME      CONSTRAINT [DF__invoice_i__audit__2AA05119] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__invoice___A0AA8666437C14C7] PRIMARY KEY CLUSTERED ([invoice_item_key] ASC),
    CONSTRAINT [FK_invoice_item_invoice] FOREIGN KEY ([invoice_key]) REFERENCES [dbo].[invoice] ([invoice_key]),
    CONSTRAINT [FK_invoice_item_invoice_status] FOREIGN KEY ([invoice_item_status_key]) REFERENCES [dbo].[invoice_status] ([invoice_status_key]),
    CONSTRAINT [FK_invoice_item_product] FOREIGN KEY ([product_key]) REFERENCES [dbo].[product] ([product_key])
);


GO
CREATE TRIGGER [tgr_invoice_item_audit]
    ON dbo.invoice_item
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [invoice_item] A INNER JOIN inserted B
		ON A.invoice_item_key = B.invoice_item_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [invoice_item] A INNER JOIN inserted B
		ON A.invoice_item_key = B.invoice_item_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [invoice_item] A INNER JOIN deleted B
		ON A.invoice_item_key = B.invoice_item_key
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
				   ,'invoice_item'
				   ,'invoice_item'
				   ,@old_xml
				   ,@new_xml)

    END

GO
CREATE TRIGGER [tgr_invoice_item_audit_del]
    ON dbo.invoice_item
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
				   ,'invoice_item'
				   ,'invoice_item record deleted'
				   ,@old_xml)

    END
