CREATE TABLE [dbo].[order_item] (
    [order_item_key]           INT           CONSTRAINT [DF__order_ite__order__5224328E] DEFAULT (NEXT VALUE FOR [order_item_key_seq]) NOT NULL,
    [order_key]                INT           NOT NULL,
    [order_item_seq]           INT           CONSTRAINT [DF_order_item_order_item_seq] DEFAULT ((1)) NOT NULL,
    [product_key]              INT           NOT NULL,
    [product_name]             VARCHAR (150) NULL,
    [product_desc]             VARCHAR (255) NULL,
    [order_item_quantity]      INT           NOT NULL,
    [shipto_addr_key]          INT           NOT NULL,
    [billto_addr_key]          INT           NOT NULL,
    [order_item_ship_date]     DATETIME      NULL,
    [order_item_complete_date] DATETIME      NULL,
    [order_item_price_per]     MONEY         NOT NULL,
    [order_item_line_sum]      MONEY         NOT NULL,
    [order_item_acct_rep_key]  INT           NULL,
    [order_item_sales_rep_key] INT           NULL,
    [order_item_status_key]    INT           NOT NULL,
    [audit_add_user_id]        VARCHAR (30)  CONSTRAINT [DF__order_ite__audit__1332DBDC] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]       DATETIME      CONSTRAINT [DF__order_ite__audit__14270015] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]     VARCHAR (30)  CONSTRAINT [DF__order_ite__audit__151B244E] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]    DATETIME      CONSTRAINT [DF__order_ite__audit__160F4887] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__order_it__29F91EC22F9D09AE] PRIMARY KEY CLUSTERED ([order_item_key] ASC),
    CONSTRAINT [FK_order_item_address] FOREIGN KEY ([shipto_addr_key]) REFERENCES [dbo].[address] ([address_key]),
    CONSTRAINT [FK_order_item_address1] FOREIGN KEY ([billto_addr_key]) REFERENCES [dbo].[address] ([address_key]),
    CONSTRAINT [FK_order_item_order_header] FOREIGN KEY ([order_key]) REFERENCES [dbo].[order_header] ([order_key]),
    CONSTRAINT [FK_order_item_order_status] FOREIGN KEY ([order_item_status_key]) REFERENCES [dbo].[order_status] ([order_status_key]),
    CONSTRAINT [FK_order_item_product] FOREIGN KEY ([product_key]) REFERENCES [dbo].[product] ([product_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150729-163957]
    ON [dbo].[order_item]([order_key] ASC, [order_item_seq] ASC);


GO
CREATE TRIGGER [tgr_order_item_audit]
    ON dbo.order_item
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [order_item] A INNER JOIN inserted B
		ON A.order_item_key = B.order_item_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [order_item] A INNER JOIN inserted B
		ON A.order_item_key = B.order_item_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [order_item] A INNER JOIN deleted B
		ON A.order_item_key = B.order_item_key
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
				   ,'order_item'
				   ,'order_item'
				   ,@old_xml
				   ,@new_xml)

    END

GO
CREATE TRIGGER [tgr_order_item_audit_del]
    ON dbo.order_item
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
				   ,'order_item'
				   ,'order_item record deleted'
				   ,@old_xml)

    END
