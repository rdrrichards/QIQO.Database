CREATE TABLE [dbo].[comment_type] (
    [comment_type_key]      INT           DEFAULT (NEXT VALUE FOR [comment_type_key_seq]) NOT NULL,
    [comment_type_category] VARCHAR (50)  NOT NULL,
    [comment_type_code]     VARCHAR (10)  NOT NULL,
    [comment_type_name]     VARCHAR (50)  NOT NULL,
    [comment_type_desc]     VARCHAR (150) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([comment_type_key] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150704-170821]
    ON [dbo].[comment_type]([comment_type_category] ASC, [comment_type_code] ASC, [comment_type_name] ASC);


GO

CREATE TRIGGER [tgr_comment_type_audit]
    ON [comment_type]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [comment_type] A INNER JOIN inserted B
		ON A.comment_type_key = B.comment_type_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [comment_type] A INNER JOIN inserted B
		ON A.comment_type_key = B.comment_type_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [comment_type] A INNER JOIN deleted B
		ON A.comment_type_key = B.comment_type_key
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
				   ,'comment_type'
				   ,'comment_type'
				   ,@old_xml
				   ,@new_xml)

    END




GO

CREATE TRIGGER [tgr_comment_type_audit_del]
    ON [comment_type]
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
				   ,'comment_type'
				   ,'comment_type record deleted'
				   ,@old_xml
				   )

    END



