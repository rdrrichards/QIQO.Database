CREATE TABLE [dbo].[order_status] (
    [order_status_key]      INT           DEFAULT (NEXT VALUE FOR [order_status_key_seq]) NOT NULL,
    [order_status_code]     VARCHAR (10)  NOT NULL,
    [order_status_name]     VARCHAR (50)  NOT NULL,
    [order_status_type]     VARCHAR (50)  NOT NULL,
    [order_status_desc]     VARCHAR (255) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__order_sta__audit__05D8E0BE] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__order_sta__audit__06CD04F7] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__order_sta__audit__07C12930] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__order_sta__audit__08B54D69] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__order_st__2AF04746C4095723] PRIMARY KEY CLUSTERED ([order_status_key] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150704-165454]
    ON [dbo].[order_status]([order_status_code] ASC, [order_status_name] ASC, [order_status_type] ASC);


GO
CREATE TRIGGER [tgr_order_status_audit]
    ON [order_status]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [order_status] A INNER JOIN inserted B
		ON A.order_status_key = B.order_status_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [order_status] A INNER JOIN inserted B
		ON A.order_status_key = B.order_status_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [order_status] A INNER JOIN deleted B
		ON A.order_status_key = B.order_status_key
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
				   ,'order_status'
				   ,'order_status'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_order_status_audit_del]
    ON [order_status]
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
				   ,'order_status'
				   ,'order_status record deleted'
				   ,@old_xml)

    END



