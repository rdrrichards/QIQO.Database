CREATE TABLE [dbo].[chart_of_accounts] (
    [coa_key]               INT          CONSTRAINT [DF__chart_of___coa_k__6477ECF3] DEFAULT (NEXT VALUE FOR [chart_of_accounts_key_seq]) NOT NULL,
    [company_key]           INT          NOT NULL,
    [acct_no]               VARCHAR (10) NOT NULL,
    [acct_type]             VARCHAR (30) CONSTRAINT [DF_chart_of_accounts_acct_type] DEFAULT ('Asset') NOT NULL,
    [department_no]         VARCHAR (10) CONSTRAINT [DF_chart_of_accounts_department_no] DEFAULT ('') NOT NULL,
    [lob_no]                VARCHAR (10) CONSTRAINT [DF_chart_of_accounts_lob_no] DEFAULT ('') NOT NULL,
    [acct_name]             VARCHAR (50) NOT NULL,
    [balance_type]          VARCHAR (10) CONSTRAINT [DF_chart_of_accounts_balance_type] DEFAULT ('Debit') NOT NULL,
    [bank_acct_flg]         CHAR (1)     CONSTRAINT [DF_chart_of_accounts_bank_acct_flg] DEFAULT ('N') NOT NULL,
    [report]                VARCHAR (50) CONSTRAINT [DF_chart_of_accounts_report] DEFAULT ('Balance Sheet') NOT NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__chart_of___audit__19DFD96B] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__chart_of___audit__1AD3FDA4] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__chart_of___audit__1BC821DD] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__chart_of___audit__1CBC4616] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__chart_of__41CF93A519ADF691] PRIMARY KEY CLUSTERED ([coa_key] ASC),
    CONSTRAINT [FK_chart_of_accounts_company] FOREIGN KEY ([company_key]) REFERENCES [dbo].[company] ([company_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ui_chart_of_accounts_cadl]
    ON [dbo].[chart_of_accounts]([company_key] ASC, [acct_no] ASC, [department_no] ASC, [lob_no] ASC);


GO
CREATE TRIGGER [tgr_chart_of_accounts_audit]
    ON [chart_of_accounts]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [chart_of_accounts] A INNER JOIN inserted B
		ON A.coa_key = B.coa_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [chart_of_accounts] A INNER JOIN inserted B
		ON A.coa_key = B.coa_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [chart_of_accounts] A INNER JOIN deleted B
		ON A.coa_key = B.coa_key
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
				   ,'chart_of_accounts'
				   ,'chart_of_accounts'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_chart_of_accounts_audit_del]
    ON [chart_of_accounts]
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
				   ,'chart_of_accounts'
				   ,'chart_of_accounts record deleted'
				   ,@old_xml
				   )

    END

