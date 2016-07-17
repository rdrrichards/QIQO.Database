CREATE TABLE [dbo].[ledger_txn] (
    [ledger_txn_key]        INT          CONSTRAINT [DF__general_l__gener__3493CFA7] DEFAULT (NEXT VALUE FOR [general_ledger_txn_key_seq]) NOT NULL,
    [ledger_key]            INT          NOT NULL,
    [txn_comment]           VARCHAR (50) NOT NULL,
    [acct_from]             VARCHAR (10) NOT NULL,
    [dept_from]             VARCHAR (10) NULL,
    [lob_from]              VARCHAR (10) NULL,
    [acct_to]               VARCHAR (10) NOT NULL,
    [dept_to]               VARCHAR (10) NULL,
    [lob_to]                VARCHAR (10) NULL,
    [txn_num]               INT          NOT NULL,
    [post_date]             DATETIME     NULL,
    [entry_date]            DATETIME     NOT NULL,
    [credit]                MONEY        NOT NULL,
    [debit]                 MONEY        NOT NULL,
    [entity_key]            INT          CONSTRAINT [DF_general_ledger_txn_entity_key] DEFAULT ((0)) NOT NULL,
    [entity_type_key]       INT          CONSTRAINT [DF_general_ledger_txn_entity_type_key] DEFAULT ((0)) NOT NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__general_l__audit__2739D489] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__general_l__audit__282DF8C2] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__general_l__audit__29221CFB] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__general_l__audit__2A164134] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__general___5E981A79B1CA4153] PRIMARY KEY CLUSTERED ([ledger_txn_key] ASC),
    CONSTRAINT [FK_general_ledger_txn_general_ledger] FOREIGN KEY ([ledger_key]) REFERENCES [dbo].[ledger] ([ledger_key])
);


GO
CREATE TRIGGER [tgr_general_ledger_txn_audit_del]
    ON [ledger_txn]
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
				   ,'general_ledger_txn'
				   ,'general_ledger_txn record deleted'
				   ,@old_xml)

    END


GO
CREATE TRIGGER [tgr_ledger_txn_audit]
    ON [ledger_txn]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [ledger_txn] A INNER JOIN inserted B
		ON A.ledger_txn_key = B.ledger_txn_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [ledger_txn] A INNER JOIN inserted B
		ON A.ledger_txn_key = B.ledger_txn_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [ledger_txn] A INNER JOIN deleted B
		ON A.ledger_txn_key = B.ledger_txn_key
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
				   ,'general_ledger_txn'
				   ,'general_ledger_txn'
				   ,@old_xml
				   ,@new_xml)

    END

