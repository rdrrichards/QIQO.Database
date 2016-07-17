CREATE TABLE [dbo].[entity_entity] (
    [entity_entity_key]         INT           CONSTRAINT [DF__entity_en__entit__0E6E26BF] DEFAULT (NEXT VALUE FOR [entity_entity_key_seq]) NOT NULL,
    [primary_entity_key]        INT           NOT NULL,
    [primary_entity_type_key]   INT           NOT NULL,
    [secondary_entity_key]      INT           NOT NULL,
    [secondary_entity_type_key] INT           NOT NULL,
    [entity_entity_seq]         INT           CONSTRAINT [DF_entity_entity_entity_entity_seq] DEFAULT ((1)) NOT NULL,
    [entity_entity_role]        VARCHAR (50)  NULL,
    [comment]                   VARCHAR (150) NOT NULL,
    [start_date]                DATETIME      CONSTRAINT [DF_entity_entity_start_date] DEFAULT (getdate()) NOT NULL,
    [end_date]                  DATETIME      CONSTRAINT [DF_entity_entity_end_date] DEFAULT (dateadd(year,(25),getdate())) NOT NULL,
    [audit_add_user_id]         VARCHAR (30)  CONSTRAINT [DF__entity_en__audit__7FEAFD3E] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]        DATETIME      CONSTRAINT [DF__entity_en__audit__00DF2177] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]      VARCHAR (30)  CONSTRAINT [DF__entity_en__audit__01D345B0] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime]     DATETIME      CONSTRAINT [DF__entity_en__audit__02C769E9] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_entity_entity_entity_entity_key] PRIMARY KEY NONCLUSTERED ([entity_entity_key] ASC),
    CONSTRAINT [FK_primary_entity_key_entity_type_key] FOREIGN KEY ([primary_entity_type_key]) REFERENCES [dbo].[entity_type] ([entity_type_key]),
    CONSTRAINT [FK_secondary_entity_key_entity_type_key] FOREIGN KEY ([secondary_entity_type_key]) REFERENCES [dbo].[entity_type] ([entity_type_key])
);


GO
CREATE UNIQUE CLUSTERED INDEX [NonClusteredIndex-20150701-155340]
    ON [dbo].[entity_entity]([primary_entity_key] ASC, [primary_entity_type_key] ASC, [secondary_entity_key] ASC, [secondary_entity_type_key] ASC, [entity_entity_seq] ASC);


GO
CREATE TRIGGER [tgr_entity_entity_audit]
    ON [entity_entity]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [entity_entity] A INNER JOIN inserted B
		ON A.entity_entity_key = B.entity_entity_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [entity_entity] A INNER JOIN inserted B
		ON A.entity_entity_key = B.entity_entity_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [entity_entity] A INNER JOIN deleted B
		ON A.entity_entity_key = B.entity_entity_key
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
				   ,'entity_entity'
				   ,'entity_entity'
				   ,@old_xml
				   ,@new_xml)

    END


GO
CREATE TRIGGER [tgr_entity_entity_audit_del]
    ON [entity_entity]
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
				   ,'entity_entity'
				   ,'entity_entity record deleted'
				   ,@old_xml
				   )

    END

