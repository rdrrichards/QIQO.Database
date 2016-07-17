CREATE TABLE [dbo].[user_session] (
    [session_key]           BIGINT       CONSTRAINT [DF_user_session_session_key] DEFAULT (NEXT VALUE FOR [user_session_key_seq]) NOT NULL,
    [session_code]          VARCHAR (50) NOT NULL,
    [host_name]             VARCHAR (50) NOT NULL,
    [user_domain]           VARCHAR (75) NOT NULL,
    [user_name]             VARCHAR (30) NOT NULL,
    [process_id]            INT          NOT NULL,
    [company_key]           INT          NOT NULL,
    [start_date]            DATETIME     CONSTRAINT [DF_user_session_start_date] DEFAULT (getdate()) NOT NULL,
    [end_date]              DATETIME     NULL,
    [active_flg]            BIT          CONSTRAINT [DF_user_session_active_flg] DEFAULT ((1)) NOT NULL,
    [audit_add_user_id]     VARCHAR (30) CONSTRAINT [DF__user_sess__audit__2F2FFC0C] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME     CONSTRAINT [DF__user_sess__audit__30242045] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30) CONSTRAINT [DF__user_sess__audit__3118447E] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME     CONSTRAINT [DF__user_sess__audit__320C68B7] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_user_session] PRIMARY KEY NONCLUSTERED ([session_key] ASC)
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20150726-073407]
    ON [dbo].[user_session]([session_code] ASC) WITH (FILLFACTOR = 80);


GO
CREATE TRIGGER [tgr_user_session_audit]
    ON [user_session]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [user_session] A INNER JOIN inserted B
		ON A.session_key = B.session_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [user_session] A INNER JOIN inserted B
		ON A.session_key = B.session_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [user_session] A INNER JOIN deleted B
		ON A.session_key = B.session_key
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
				   ,'user_session'
				   ,'user_session'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_user_session_audit_del]
    ON [user_session]
    AFTER DELETE
    AS
    BEGIN
        SET NOCOUNT ON
		DECLARE @old_xml XML

		SELECT @old_xml = (SELECT B.* 
		FROM deleted B
		FOR XML RAW, ELEMENTS)

		INSERT INTO [dbo].[audit_log]
				   ([audit_action]
				   ,[audit_bus_obj]
				   ,[audit_comment]
				   ,[audit_data_old]
				   )
			 VALUES
				   ('D' 
				   ,'user_session'
				   ,'user_session record deleted'
				   ,@old_xml
				   )

    END

