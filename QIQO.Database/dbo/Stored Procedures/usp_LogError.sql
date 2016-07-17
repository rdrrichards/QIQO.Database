CREATE PROCEDURE [dbo].[usp_LogError]
@table_name nvarchar(128) = '',
@procedure_name nvarchar(128) = '',
@step nchar(1) = ''
AS
INSERT INTO error_log (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, TableName, ProcedureName, ProcedureStep)
SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage, @table_name, @procedure_name, @step
