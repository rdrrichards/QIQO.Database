CREATE TABLE [dbo].[account] (
    [account_key]           INT           DEFAULT (NEXT VALUE FOR [account_key_seq]) NOT NULL,
    [company_key]           INT           NOT NULL,
    [account_type_key]      INT           NOT NULL,
    [account_code]          VARCHAR (30)  NOT NULL,
    [account_name]          VARCHAR (150) NOT NULL,
    [account_desc]          VARCHAR (254) NOT NULL,
    [account_dba]           VARCHAR (150) NULL,
    [account_start_date]    DATETIME      NOT NULL,
    [account_end_date]      DATETIME      NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__account__audit_a__6B24EA82] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__account__audit_a__6C190EBB] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__account__audit_u__6D0D32F4] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__account__audit_u__6E01572D] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__account__BE257CB3F6B26FD0] PRIMARY KEY CLUSTERED ([account_key] ASC),
    CONSTRAINT [FK_account_account_type] FOREIGN KEY ([account_type_key]) REFERENCES [dbo].[account_type] ([account_type_key]),
    CONSTRAINT [FK_account_company] FOREIGN KEY ([company_key]) REFERENCES [dbo].[company] ([company_key])
);


GO
CREATE NONCLUSTERED INDEX [IX_account]
    ON [dbo].[account]([account_key] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150705-105816]
    ON [dbo].[account]([company_key] ASC, [account_code] ASC, [account_name] ASC);


GO
CREATE TRIGGER [tgr_account_audit]
    ON [account]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [account] A INNER JOIN inserted B
		ON A.account_key = B.account_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [account] A INNER JOIN inserted B
		ON A.account_key = B.account_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [account] A INNER JOIN deleted B
		ON A.account_key = B.account_key
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
				   ,'account'
				   ,'account'
				   ,@old_xml
				   ,@new_xml)
    END




GO
CREATE TRIGGER [tgr_account_audit_del]
    ON [account]
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
				   ,'account'
				   ,'account record deleted'
				   ,@old_xml)
    END



