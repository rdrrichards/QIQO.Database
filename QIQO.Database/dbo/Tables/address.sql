CREATE TABLE [dbo].[address] (
    [address_key]           INT           DEFAULT (NEXT VALUE FOR [address_key_seq]) NOT NULL,
    [address_type_key]      INT           NOT NULL,
    [entity_key]            INT           NOT NULL,
    [entity_type_key]       INT           NOT NULL,
    [address_line_1]        VARCHAR (75)  NOT NULL,
    [address_line_2]        VARCHAR (75)  NULL,
    [address_line_3]        VARCHAR (75)  NULL,
    [address_line_4]        VARCHAR (75)  NULL,
    [address_city]          VARCHAR (75)  NOT NULL,
    [address_state_prov]    VARCHAR (5)   NOT NULL,
    [address_county]        VARCHAR (50)  NOT NULL,
    [address_country]       VARCHAR (50)  NOT NULL,
    [address_postal_code]   VARCHAR (20)  NOT NULL,
    [address_notes]         VARCHAR (150) NULL,
    [address_default_flg]   BIT           CONSTRAINT [DF_address_address_default_flg] DEFAULT ((0)) NOT NULL,
    [address_active_flg]    BIT           CONSTRAINT [DF_address_address_active_flg] DEFAULT ((1)) NOT NULL,
    [audit_add_user_id]     VARCHAR (30)  CONSTRAINT [DF__address__audit_a__4316F928] DEFAULT (suser_sname()) NOT NULL,
    [audit_add_datetime]    DATETIME      CONSTRAINT [DF__address__audit_a__440B1D61] DEFAULT (getdate()) NOT NULL,
    [audit_update_user_id]  VARCHAR (30)  CONSTRAINT [DF__address__audit_u__44FF419A] DEFAULT (suser_sname()) NOT NULL,
    [audit_update_datetime] DATETIME      CONSTRAINT [DF__address__audit_u__45F365D3] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__address__530D801051774A01] PRIMARY KEY CLUSTERED ([address_key] ASC),
    CONSTRAINT [FK_address_address_type] FOREIGN KEY ([address_type_key]) REFERENCES [dbo].[address_type] ([address_type_key]),
    CONSTRAINT [FK_address_entity_type] FOREIGN KEY ([entity_type_key]) REFERENCES [dbo].[entity_type] ([entity_type_key])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20150705-105452]
    ON [dbo].[address]([address_type_key] ASC, [entity_key] ASC, [entity_type_key] ASC);


GO
CREATE TRIGGER [tgr_address_audit]
    ON [address]
    FOR INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON

		UPDATE A SET
			A.audit_add_datetime = ISNULL(A.audit_add_datetime, GETDATE()),
			A.audit_add_user_id = ISNULL(A.audit_add_user_id, SUSER_SNAME()),
			A.audit_update_datetime = GETDATE(),
			A.audit_update_user_id = SUSER_SNAME()
		FROM [address] A INNER JOIN inserted B
		ON A.address_key = B.address_key

		DECLARE @old_xml XML, @new_xml XML

		SELECT @new_xml = (SELECT B.* 
		FROM [address] A INNER JOIN inserted B
		ON A.address_key = B.address_key
		FOR XML RAW, ELEMENTS)

		SELECT @old_xml = (SELECT B.* 
		FROM [address] A INNER JOIN deleted B
		ON A.address_key = B.address_key
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
				   ,'address'
				   ,'address'
				   ,@old_xml
				   ,@new_xml)

    END




GO
CREATE TRIGGER [tgr_address_audit_del]
    ON [address]
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
				   ,'address'
				   ,'address record deleted'
				   ,@old_xml
				   )

    END



