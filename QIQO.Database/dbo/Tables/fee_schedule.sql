CREATE TABLE [dbo].[fee_schedule] (
    [fee_schedule_key]        INT             DEFAULT (NEXT VALUE FOR [fee_schedule_key_seq]) NOT NULL,
    [company_key]             INT             NOT NULL,
    [account_key]             INT             NOT NULL,
    [product_key]             INT             NOT NULL,
    [fee_schedule_start_date] DATETIME        NOT NULL,
    [fee_schedule_end_date]   DATETIME        NOT NULL,
    [fee_schedule_type]       CHAR (1)        NOT NULL,
    [fee_schedule_value]      NUMERIC (10, 5) NOT NULL,
    [audit_add_user_id]       VARCHAR (30)    CONSTRAINT [DF__fee_sched__audit__58520D30] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]      DATETIME        CONSTRAINT [DF__fee_sched__audit__59463169] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]    VARCHAR (30)    CONSTRAINT [DF__fee_sched__audit__5A3A55A2] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]   DATETIME        CONSTRAINT [DF__fee_sched__audit__5B2E79DB] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__fee_sche__944A105B08709288] PRIMARY KEY CLUSTERED ([fee_schedule_key] ASC),
    CONSTRAINT [CK_fee_schedule_type] CHECK ([fee_schedule_type]='P' OR [fee_schedule_type]='F'),
    CONSTRAINT [FK_fee_schedule_account] FOREIGN KEY ([account_key]) REFERENCES [dbo].[account] ([account_key]),
    CONSTRAINT [FK_fee_schedule_company] FOREIGN KEY ([company_key]) REFERENCES [dbo].[company] ([company_key]),
    CONSTRAINT [FK_fee_schedule_product] FOREIGN KEY ([product_key]) REFERENCES [dbo].[product] ([product_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_fee_schedule_multi_key]
    ON [dbo].[fee_schedule]([company_key] ASC, [account_key] ASC, [product_key] ASC, [fee_schedule_start_date] ASC)
    INCLUDE([fee_schedule_type], [fee_schedule_value]);


GO
CREATE TRIGGER [tgr_fee_schedule_audit]
    ON [fee_schedule]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [fee_schedule] A INNER JOIN inserted B
		ON A.fee_schedule_key = B.fee_schedule_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [fee_schedule] A INNER JOIN inserted B
		ON A.fee_schedule_key = B.fee_schedule_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [fee_schedule] A INNER JOIN deleted B
		ON A.fee_schedule_key = B.fee_schedule_key
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
				   ,'fee_schedule'
				   ,'fee_schedule'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_fee_schedule_audit_del]
    ON [fee_schedule]
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
				   ,'fee_schedule'
				   ,'fee_schedule record deleted'
				   ,@old_xml)

    END



