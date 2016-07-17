CREATE TABLE [dbo].[ledger] (
    [ledger_key]            INT           DEFAULT (NEXT VALUE FOR [general_ledger_key_seq]) NOT NULL,
    [company_key]           INT           NOT NULL,
    [ledger_code]           VARCHAR (10)  NOT NULL,
    [ledger_name]           VARCHAR (50)  NOT NULL,
    [ledger_desc]           VARCHAR (255) NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__general_l__audit__208CD6FA] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__general_l__audit__2180FB33] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__general_l__audit__22751F6C] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__general_l__audit__236943A5] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__general___5BB881F849F1E255] PRIMARY KEY CLUSTERED ([ledger_key] ASC),
    CONSTRAINT [FK_general_ledger_company] FOREIGN KEY ([company_key]) REFERENCES [dbo].[company] ([company_key])
);


GO
CREATE TRIGGER [tgr_general_ledger_audit_del]
    ON [ledger]
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
				   ,'general_ledger'
				   ,'general_ledger record deleted'
				   ,@old_xml)

    END




GO
CREATE TRIGGER [tgr_ledger_audit]
    ON [ledger]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [ledger] A INNER JOIN inserted B
		ON A.ledger_key = B.ledger_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [ledger] A INNER JOIN inserted B
		ON A.ledger_key = B.ledger_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [ledger] A INNER JOIN deleted B
		ON A.ledger_key = B.ledger_key
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
				   ,'general_ledger'
				   ,'general_ledger'
				   ,@old_xml
				   ,@new_xml)

    END



